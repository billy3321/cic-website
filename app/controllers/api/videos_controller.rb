class Api::VideosController < ApplicationController
  respond_to :json
  before_action :set_video, only: [:show]

  swagger_controller :videos, 'Videos'

  swagger_api :index do
    summary '影片列表'
    notes '回應、查詢影片資訊'
    param :query, :query, :string, :optional, "查詢影片標題、內文或會議資訊"
    param :query, :limit, :integer, :optional, "一次顯示多少筆"
    param :query, :offset, :integer, :optional, "從第幾筆開始顯示"
    response :ok, "Success", :APIVideoIndex
  end

  def index
    limit = params[:limit].blank? ? 10 : params[:limit]
    ransack_params = {}
    ransack_params[:title_or_content_or_meeting_description_cont] = params[:query] if params[:query]
    if ransack_params.blank?
      @videos = Video.includes(:committee, ad_session: :ad, legislators: :elections).published.offset(params[:offset]).limit(limit)
      @videos_count = Video.published.count
    else
      @videos = Video.includes(:committee, ad_session: :ad, legislators: :elections).ransack(ransack_params).result(distinct: true)
        .published.offset(params[:offset]).limit(limit)
      @videos_count = Video.ransack({title_or_content_or_meeting_description_cont: params[:query]}).result(distinct: true)
        .published.count
    end
    respond_with(@videos, @videos_count)
  end

  swagger_api :show do
    summary '單一影片'
    notes '回應單一影片資訊'
    param :path, :id, :integer, :optional, "影片 Id"
    response :ok, "Success", :APIVideoShow
    response :not_found
  end

  def show
    respond_with(@video)
  end

  swagger_model :APIVideoIndex do
    description "Video index structure"
    property :count, :integer, :required, "影片數"
    property :videos, :array, :required, "影片列表", items: { '$ref' => :Video }
    property :status, :string, :required, "狀態"
  end

  swagger_model :APIVideoShow do
    description "Video show structure"
    property :count, :integer, :required, "影片數"
    property :videos, nil, :required, "影片資訊", '$ref' => :Video
    property :status, :string, :required, "狀態"
  end

  swagger_model :Video do
    description "影片"
    property :legislators, :array, :required, "立委列表", items: { '$ref' => :Legislator }
    property :ad_session, nil, :required, "會期資料", '$ref' => :AdSession
    property :committee, nil, :optional, '委員會資料', '$ref' => :Committee
    property :id, :integer, :required, "影片 Id"
    property :title, :string, :required, "影片標題"
    property :content, :text, :required, "影片內文"
    property :video_type, :string, :required, "影片類型"
    property :meeting_description, :string, :optional, "會議描述"
    property :youtube_url, :string, :required, "Youtube 連結"
    property :youtube_id, :string, :required, "Youtube Id"
    property :image, :string, :required, "圖片網址"
    property :ivod_url, :string, :optional, "Ivod 網址"
    property :source_url, :string, :optional, "來源網址"
    property :source_name, :string, :optional, "來源名稱"
    property :time_start, :time, :optional, "開始時間"
    property :time_end, :time, :optional, "結束時間"
    property :date, :date, :required, "日期"
    property :target, :string, :optional, "質詢對象"
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

  def set_video
    @video = params[:id] ? Video.find(params[:id]) : Video.new(video_params)
  end
end