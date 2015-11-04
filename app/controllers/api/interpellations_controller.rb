class Api::InterpellationsController < ApplicationController
  respond_to :json
  before_action :set_interpellation, only: [:show]

  swagger_controller :interpellations, 'Interpellations'

  swagger_api :index do
    summary '質詢列表'
    notes '回應、查詢質詢資訊'
    param :query, :query, :string, :optional, "查詢質詢標題、內文或會議資訊"
    param :query, :limit, :integer, :optional, "一次顯示多少筆"
    param :query, :offset, :integer, :optional, "從第幾筆開始顯示"
    response :ok, "Success", :APIInterpellationIndex
  end

  def index
    limit = params[:limit].blank? ? 10 : params[:limit]
    ransack_params = {}
    ransack_params[:title_or_content_or_meeting_description_cont] = params[:query] if params[:query]
    if ransack_params.blank?
      @interpellations = Interpellation.includes(:committee, ad_session: :ad, legislators: :elections).published.offset(params[:offset]).limit(limit)
      @interpellations_count = Interpellation.published.count
    else
      @interpellations = Interpellation.includes(:committee, :ad_session, legislators: :elections).ransack(ransack_params).result(distinct: true)
        .published.offset(params[:offset]).limit(limit)
      @interpellations_count = Interpellation.ransack(ransack_params).result(distinct: true)
        .published.count
    end
    respond_with(@interpellations, @interpellations_count)
  end

  swagger_api :show do
    summary '單一質詢'
    notes '回應單一質詢資訊'
    param :path, :id, :integer, :optional, "質詢 Id"
    response :ok, "Success", :APIInterpellationShow
    response :not_found
  end

  def show
    respond_with(@interpellation)
  end

  swagger_model :APIInterpellationIndex do
    description "Interpellations index structure"
    property :count, :integer, :required, "質詢數"
    property :interpellations, :array, :required, "質詢列表", items: { '$ref' => :Interpellation }
    property :status, :string, :required, "狀態"
  end

  swagger_model :APIInterpellationShow do
    description "Interpellations show structure"
    property :count, :integer, :required, "質詢數"
    property :interpellations, nil, :required, "質詢資料", '$ref' => :Interpellation
    property :status, :string, :required, "狀態"
  end

  swagger_model :Interpellation do
    description "質詢"
    property :legislators, :array, :required, "立委列表", items: { '$ref' => :Legislator }
    property :ad_session, nil, :required, "會期資料", '$ref' => :AdSession
    property :committee, nil, :required, '委員會資料', '$ref' => :Committee
    property :id, :integer, :required, "質詢 Id"
    property :title, :string, :required, "質詢標題"
    property :content, :text, :required, "質詢內文"
    property :meeting_description, :string, :required, "會議內容"
    property :ivod_url, :string, :optional, "IVOD連結"
    property :time_start, :time, :optional, "開始時間"
    property :time_end, :time, :optional, "結束時間"
    property :target, :string, :optional, "質詢對象"
    property :date, :date, :required, "日期"
    property :comment, :text, :optional, "心得"
    property :interpellation_type, :string, :required, "質詢類別"
    property :record_url, :string, :optional, "記錄網址"
    property :created_at, :datetime, :required, "建立時間"
    property :updated_at, :datetime, :required, "更新時間"
  end

  swagger_model :Ad do
    description "屆次"
    property :id, :integer, :required, "屆次 Id"
    property :name, :string, :required, "屆次名稱"
    property :vote_date, :date, :required, "投票日期"
    property :term_start, :date, :required, "任期開始日期"
    property :term_end, :date, :required, "任期結束日期"
  end

  swagger_model :AdSession do
    description "會期"
    property :id, :integer, :required, "會期 Id"
    property :name, :string, :required, "會期名稱"
    property :session, :integer, :required, "第幾會期之會期數"
    property :regular, :boolean, :required, "正式或臨時會"
    property :date_start, :date, :required, "開始日期"
    property :date_end, :date, :required, "結束日期"
    property :ad, nil, :required, "屆次", '$ref' => :Ad
  end

  swagger_model :Legislator do
    description "立委"
    property :id, :integer, :required, "立委 Id"
    property :name, :string, :required, "立委名稱"
    property :image, :string, :required, "立委圖片"
    property :party, nil, :required, "政黨", '$ref' => :Party
  end

  swagger_model :Committee do
    description "委員會"
    property :id, :integer, :required, "委員會 Id"
    property :name, :string, :required, "委員會名稱"
  end

  private

  def set_interpellation
    @interpellation = params[:id] ? Interpellation.find(params[:id]) : Interpellation.new(interpellation_params)
  end
end