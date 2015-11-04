class Api::Ccw::LegislatorsController < ApplicationController
  respond_to :json
  before_filter :find_ad_session
  before_action :set_legislator, only: [:show]

  swagger_controller :ccw_legislator_data, 'CcwLegislatorData'

  swagger_api :index do
    summary '公督盟立委統計列表'
    notes '回應公督盟立委統計列表資訊'
    param :path, :ad_session_id, :integer, :required, "會期 Id"
    param :query, :query, :string, :optional, "查詢立委姓名"
    param :query, :limit, :integer, :optional, "一次顯示多少筆"
    param :query, :offset, :integer, :optional, "從第幾筆開始顯示"
    param :query, :party, :string, :optional, "查詢該黨派立委"
    response :ok, "Success", :APICcwLegislatorDatumIndex
    response :not_found
  end

  def index
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
    respond_with(@ccw_legislator_data, @ccw_legislator_data_count)
  end

  swagger_api :show do
    summary '公督盟立委統計'
    notes '回應公督盟立委統計資訊'
    param :path, :ad_session_id, :integer, :required, "會期 Id"
    param :path, :id, :integer, :required, "立委 Id"
    response :ok, "Success", :APICcwLegislatorDatumShow
    response :not_found
  end

  def show
    @ccw_legislator_datum = @legislator.get_session_ccw_data(@ad_session.id).first
    @sc_committee = @legislator.get_session_committee(@ad_session.id, 'sc').first
    @yc_committee = Committee.find(19)
    @sc_committee_datum = @sc_committee.ccw_committee_data.where(ad_session_id: @ad_session.id).first
    @yc_committee_datum = @yc_committee.ccw_committee_data.where(ad_session_id: @ad_session.id).first
    @ccw_citizen_score = @ad_session.ccw_citizen_score
    if @sc_committee_datum.blank? or @yc_committee_datum.blank? or @ccw_citizen_score.blank?
      @status = false
    else
      @status = true
    end
    respond_with(@ccw_legislator_datum, @sc_committee, @yc_committee, @ccw_citizen_score)
  end

  swagger_model :APICcwLegislatorDatumIndex do
    description "CcwLegislatorData index structure"
    property :count, :integer, :required, "立委數"
    property :ad_session, nil, :required, "會期資料", '$ref' => :AdSession
    property :legislators, :array, :required, "立委數據列表", items: { '$ref' => :CcwLegislatorDatum }
    property :status, :string, :required, "狀態"
  end

  swagger_model :APICcwLegislatorDatumShow do
    description "CcwLegislatorData show structure"
    property :ad_session, nil, :required, "會期資料", '$ref' => :AdSession
    property :legislator, nil, :required, "立委個人統計數據", '$ref' => :CcwLegislatorDatum
    property :sc_committee, nil, :required, "委員會數據", '$ref' => :ScCommitteeDatum
    property :yc_committee, nil, :required, "院會數據", '$ref' => :YcCommitteeDatum
    property :citizen_score, nil, :required, "公民分數數據", '$ref' => :CitizenScore
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

  swagger_model :ScCommitteeDatum do
    description "委員會統計資料"
    property :committee, nil, :required, '委員會資料', '$ref' => :Committee
    property :should_attendance, :integer, :required, "應出席數"
    property :actually_average_attendance, :float, :required, "平均出席數"
    property :avaliable_interpellation_count, :integer, :optional, "可質詢數"
    property :actually_average_interpellation_count, :float, :optional, "平均質詢數"
  end

  swagger_model :YcCommitteeDatum do
    description "院會統計資料"
    property :committee, nil, :required, '院會資料', '$ref' => :Committee
    property :should_attendance, :integer, :required, "應出席數"
    property :actually_average_attendance, :float, :required, "平均出席數"
  end

  swagger_model :Committee do
    description "委員會"
    property :id, :integer, :required, "委員會 ID"
    property :name, :string, :required, "委員會名稱"
  end

  swagger_model :CitizenScore do
    description "公民分數"
    property :total, :integer, :required, "公民評分滿分"
    property :average, :float, :required, "平均公民評分"
  end

  swagger_model :CcwLegislatorDatum do
    description "立委統計資料"
    property :id, :integer, :required, "立委 ID"
    property :name, :string, :required, "立委姓名"
    property :image, :string, :required, "立委圖片"
    property :party, nil, :required, "政黨", '$ref' => :Party
    property :yc_attendance, :integer, :required, "院會出席數"
    property :sc_attendance, :integer, :required, "委員會出席數"
    property :sc_interpellation_count, :integer, :optional, "委員會質詢數"
    property :first_proposal_count, :integer, :required, "主提案第一人"
    property :not_first_proposal_count, :integer, :required, "非主提案第一人"
    property :budgetary_count, :integer, :required, "預算案提案"
    property :auditing_count, :integer, :required, "決算審查提案"
    property :citizen_score, :float, :required, "公民評鑑得分"
    property :new_sunshine_bills, :float, :required, "新立陽光法案"
    property :modify_sunshine_bills, :float, :required, "修正陽光法案"
    property :budgetary_deletion_passed, :float, :required, "三讀通過預算刪減案"
    property :budgetary_deletion_impact, :float, :required, "符合重大公益價值預算刪減案"
    property :budgetary_deletion_special, :float, :required, "特殊事蹟預算刪減案"
    property :special, :float, :required, "特殊事蹟"
    property :conflict_expose, :float, :required, "利益衝突迴避揭露"
    property :allow_visitor, :float, :required, "開放旁聽"
    property :human_rights_infringing_bill, :float, :required, "傷害基本人拳法案提案與連署"
    property :human_rights_infringing_budgetary, :float, :required, "侵害基本人權預算案"
    property :judicial_case, :float, :required, "司法案件"
    property :disorder, :float, :required, "脫序表現"
  end

  swagger_model :Party do
    description "政黨"
    property :id, :integer, :required, "ID"
    property :name, :string, :required, "政黨名稱"
    property :abbreviation, :string, :required, "政黨縮寫"
    property :image, :string, :required, "政黨圖片"
  end

  private

  def find_ad_session
    @ad_session = AdSession.find(params[:ad_session_id])
  end

  def set_legislator
    @legislator = params[:id] ? Legislator.find(params[:id]) : Legislator.new(legislator_params)
  end
end