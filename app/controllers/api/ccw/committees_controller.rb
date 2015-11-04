class Api::Ccw::CommitteesController < ApplicationController
  respond_to :json
  before_filter :find_ad_session
  before_action :set_committee, only: [:show]

  swagger_controller :ccw_committee_data, 'CcwCommitteeData'

  swagger_api :index do
    summary '公督盟委員會統計列表'
    notes '回應公督盟委員會統計列表資訊'
    param :path, :ad_session_id, :integer, :required, "會期 Id"
    response :ok, "Success", :APICcwCommitteeDatumIndex
    response :not_found
  end

  def index
    @ccw_committee_data = CcwCommitteeDatum.where(ad_session_id: @ad_session.id)
  end

  swagger_api :show do
    summary '公督盟單獨委員會統計'
    notes '回應公督盟委員會統計資訊'
    param :path, :ad_session_id, :integer, :required, "會期 Id"
    param :path, :id, :integer, :required, "委員會 Id"
    response :ok, "Success", :APICcwCommitteeDatumShow
    response :not_found
  end

  def show
    @ccw_committee_datum = @committee.ccw_committee_data.where(ad_session_id: @ad_session.id).first
    ccw_legislator_data_array = @committee.session_ccw_legislator_data(@ad_session.id)
    @ccw_legislator_data = CcwLegislatorDatum.includes(:legislator_committee).where(id: ccw_legislator_data_array.map(&:id))
  end

  swagger_model :APICcwCommitteeDatumIndex do
    description "CcwCommitteeData index structure"
    property :ad_session, nil, :required, "會期資料", '$ref' => :AdSession
    property :committees, :array, :required, "委員會列表", items: { '$ref' => :CcwCommitteeDatum }
    property :status, :string, :required, "狀態"
  end

  swagger_model :APICcwCommitteeDatumShow do
    description "CcwCommitteeDatum show structure"
    property :ad_session, nil, :required, "會期資料", '$ref' => :AdSession
    property :committee, nil, :required, "委員會數據", '$ref' => :CcwCommitteeDatum
    property :legislators, :array, :required, "委員會立委數據", items: { '$ref' => :CcwLegislatorDatum }
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

  swagger_model :CcwCommitteeDatum do
    description "委員會統計數據"
    property :committee, nil, :required, '委員會資料', '$ref' => :Committee
    property :should_attendance, :integer, :required, "應出席數"
    property :actually_average_attendance, :float, :required, "平均出席數"
    property :avaliable_interpellation_count, :integer, :optional, "可質詢數"
    property :actually_average_interpellation_count, :float, :optional, "平均質詢數"
  end

  swagger_model :Committee do
    description "委員會"
    property :id, :integer, :required, "委員會 ID"
    property :name, :string, :required, "委員會名稱"
  end

  swagger_model :CcwLegislatorDatum do
    description "立委統計數據"
    property :id, :integer, :required, "立委 ID"
    property :name, :string, :required, "立委姓名"
    property :image, :string, :required, "立委圖片"
    property :party, nil, :required, "政黨", '$ref' => :Party
    property :attendance, :integer, :required, "委員會出席數"
    property :interpellation_count, :integer, :optional, "委員會質詢數"
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

  def set_committee
    @committee = params[:id] ? Committee.find(params[:id]) : Committee.new(committee_params)
  end
end