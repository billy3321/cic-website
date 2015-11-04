class Api::Ccw::AdSessionsController < ApplicationController
  respond_to :json
  before_action :set_ad_session, only: [:citizen_score, :show]

  swagger_controller :ad_sessions, 'AdSessions'

  def show
  end

  swagger_api :index do
    summary '會期列表'
    notes '回應會期列表'
    response :ok, "Success", :APIAdSessionIndex
  end

  def index
    limit = params[:limit].blank? ? 10 : params[:limit]
    @ad_sessions = AdSession.includes(:ad).regulations.offset(params[:offset]).limit(limit)
    @ad_sessions_count = AdSession.includes(:ad).regulations.count
    respond_with(@ad_sessions, @ad_sessions_count)
  end

  swagger_api :citizen_score do
    summary '會期公民評鑑比較'
    notes '回應會期公民評鑑比較'
    param :path, :id, :integer, :required, "會期 Id"
    param :query, :query, :string, :optional, "查詢立委姓名"
    param :query, :limit, :integer, :optional, "一次顯示多少筆"
    param :query, :offset, :integer, :optional, "從第幾筆開始顯示"
    param :query, :party, :string, :optional, "查詢該黨派立委"
    response :ok, "Success", :APIAdSessionCitizenScore
    response :not_found
  end

  def citizen_score
    limit = params[:limit].blank? ? 10 : params[:limit]
    ransack_params = {}
    ransack_params[:legislator_committee_legislator_name_cont] = params[:query] if params[:query]
    if params[:party]
      if params[:party] == 'null'
        ransack_params[:legislator_committee_legislator_elections_party_abbreviation_null] = 1
      else
        ransack_params[:legislator_committee_legislator_elections_party_abbreviation_eq] = params[:party].upcase
      end
    end
    if ransack_params.blank?
      @ccw_legislator_data = @ad_session.ccw_legislator_data.includes({legislator_committee: {legislator: {elections: [:party, :ad] }}}).offset(params[:offset]).limit(limit)
      @ccw_legislator_data_count = @ad_session.ccw_legislator_data.count
    else
      @ccw_legislator_data = @ad_session.ccw_legislator_data.includes({legislator_committee: {legislator: {elections: [:party, :ad] }}}).ransack(ransack_params).result(distinct: true)
        .offset(params[:offset]).limit(limit)
      @ccw_legislator_data_count = @ad_session.ccw_legislator_data.ransack(ransack_params).result(distinct: true).count
    end
    @ccw_citizen_score = @ad_session.ccw_citizen_score
    respond_with(@ccw_legislator_data, @ccw_legislator_data_count)
  end

  swagger_model :APIAdSessionIndex do
    description "Ad Session index"
    property :count, :integer, :required, "會期數"
    property :ad_session, :array, :required, "會期列表", items: { '$ref' => :AdSession }
    property :status, :string, :required, "狀態"
  end

  swagger_model :APIAdSessionCitizenScore do
    description "Ad Session Citizen Score list"
    property :count, :integer, :required, "立委數"
    property :ad_session, nil, :required, "會期資料", '$ref' => :AdSession
    property :legislators, :array, :required, "立委數據列表", items: { '$ref' => :CcwLegislatorDatum }
    property :status, :string, :required, "狀態"
  end

  swagger_model :AdSession do
    description "會期"
    property :id, :integer, :required, "會期 ID"
    property :name, :string, :required, "會期名稱"
    property :date_start, :date, :required, "會期開始日期"
    property :date_end, :date, :optional, "會期結束日期"
    property :session, :integer, :required, "第幾會期"
    property :regular, :boolean, :required, "是否為正式會期"
    property :ad, nil, :required, "屆次", '$ref' => :Ad
  end

  swagger_model :Ad do
    description "屆次"
    property :id, :integer, :required, "屆次 ID"
    property :name, :string, :required, "屆次名稱"
    property :vote_date, :date, :required, "投票日期"
    property :term_start, :date, :required, "屆次開始日期"
    property :term_end, :date, :required, "屆次結束日期"
  end

  swagger_model :CcwLegislatorDatum do
    description "立委統計資料"
    property :id, :integer, :required, "立委 ID"
    property :name, :string, :required, "立委姓名"
    property :image, :string, :required, "立委圖片"
    property :party, nil, :required, "政黨", '$ref' => :Party
    property :citizen_score, :float, :required, "公民評鑑得分"
  end

  swagger_model :Party do
    description "政黨"
    property :id, :integer, :required, "ID"
    property :name, :string, :required, "政黨名稱"
    property :abbreviation, :string, :required, "政黨縮寫"
    property :image, :string, :required, "政黨圖片"
  end

  private

  def set_ad_session
    @ad_session = params[:id] ? AdSession.find(params[:id]) : AdSession.new(ad_session_params)
  end
end