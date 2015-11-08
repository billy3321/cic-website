class Api::LegislatorsController < ApplicationController
  respond_to :json
  before_action :set_legislator, except: [:index, :no_record, :has_records]

  swagger_controller :legislators, 'Legislators'

  swagger_api :index do
    summary '立委列表'
    notes '回應、查詢立委列表資訊'
    param :query, :query, :string, :optional, "查詢立委姓名"
    param :query, :limit, :integer, :optional, "一次顯示多少筆"
    param :query, :offset, :integer, :optional, "從第幾筆開始顯示"
    param :query, :ad, :integer, :optional, "查詢該屆立委"
    param :query, :in_office, :boolean, :optional, "查詢在職/不在職立委"
    param :query, :party, :string, :optional, "查詢該黨派立委"
    response :ok, "Success", :APILegislatorIndex
  end

  def index
    limit = params[:limit].blank? ? 10 : params[:limit]
    ransack_params = {}
    ransack_params[:name_cont] = params[:query] if params[:query]
    if params[:in_office]
      if params[:in_office] == 'true'
        ransack_params[:in_office_eq] = true
      elsif params[:in_office] == 'false'
        ransack_params[:in_office_eq] = false
      end
    end
    ransack_params[:elections_ad_id_eq] = params[:ad] if params[:ad]
    if params[:party]
      if params[:party] == 'null'
        ransack_params[:elections_party_abbreviation_null] = 1
      else
        ransack_params[:elections_party_abbreviation_eq] = params[:party].upcase
      end
    end
    if ransack_params.blank?
      @legislators = Legislator.includes({elections: [:party, :ad], legislator_committees: [:committee, {ad_session: :ad}]}).offset(params[:offset]).limit(limit)
      @legislators_count = Legislator.count
    else
      @legislators = Legislator.includes({elections: [:party, :ad], legislator_committees: [:committee, {ad_session: :ad}]}).ransack(ransack_params).result(distinct: true)
        .offset(params[:offset]).limit(limit)
      @legislators_count = Legislator.ransack(ransack_params).result(distinct: true).count
    end
    respond_with(@legislators, @legislators_count)
  end

  swagger_api :no_record do
    summary '沒有新聞、質詢、影片的立委列表'
    notes '回應、查詢沒有新聞、質詢、影片的立委列表資訊'
    param :query, :query, :string, :optional, "查詢立委姓名"
    param :query, :limit, :integer, :optional, "一次顯示多少筆"
    param :query, :offset, :integer, :optional, "從第幾筆開始顯示"
    param :query, :ad, :integer, :optional, "查詢該屆立委"
    param :query, :in_office, :boolean, :optional, "查詢在職/不在職立委"
    param :query, :party, :string, :optional, "查詢該黨派立委"
    response :ok, "Success", :APILegislatorIndex
  end

  def no_record
    limit = params[:limit].blank? ? 10 : params[:limit]
    ransack_params = {}
    ransack_params[:name_cont] = params[:query] if params[:query]
    if params[:in_office]
      if params[:in_office] == 'true'
        ransack_params[:in_office_eq] = true
      elsif params[:in_office] == 'false'
        ransack_params[:in_office_eq] = false
      end
    end
    ransack_params[:elections_ad_id_eq] = params[:ad] if params[:ad]
    if params[:party]
      if params[:party] == 'null'
        ransack_params[:elections_party_abbreviation_null] = 1
      else
        ransack_params[:elections_party_abbreviation_eq] = params[:party].upcase
      end
    end
    if ransack_params.blank?
      @legislators = Legislator.includes({elections: [:party, :ad], legislator_committees: [:committee, {ad_session: :ad}]}).has_no_record.offset(params[:offset]).limit(limit)
      @legislators_count = Legislator.has_no_record.length
    else
      @legislators = Legislator.includes({elections: [:party, :ad], legislator_committees: [:committee, {ad_session: :ad}]}).ransack(ransack_params).result(distinct: true).has_no_record
        .offset(params[:offset]).limit(limit)
      @legislators_count = Legislator.ransack(ransack_params).result(distinct: true).has_no_record.length
    end
    respond_with(@legislators, @legislators_count)
  end

  swagger_api :has_records do
    summary '有新聞、質詢、影片的立委列表'
    notes '回應、查詢有新聞、質詢、影片的立委列表資訊'
    param :query, :query, :string, :optional, "查詢立委姓名"
    param :query, :limit, :integer, :optional, "一次顯示多少筆"
    param :query, :offset, :integer, :optional, "從第幾筆開始顯示"
    param :query, :ad, :integer, :optional, "查詢該屆立委"
    param :query, :in_office, :boolean, :optional, "查詢在職/不在職立委"
    param :query, :party, :string, :optional, "查詢該黨派立委"
    response :ok, "Success", :APILegislatorIndex
  end

  def has_records
    limit = params[:limit].blank? ? 10 : params[:limit]
    ransack_params = {}
    ransack_params[:name_cont] = params[:query] if params[:query]
    if params[:in_office]
      if params[:in_office] == 'true'
        ransack_params[:in_office_eq] = true
      elsif params[:in_office] == 'false'
        ransack_params[:in_office_eq] = false
      end
    end
    ransack_params[:elections_ad_id_eq] = params[:ad] if params[:ad]
    if params[:party]
      if params[:party] == 'null'
        ransack_params[:elections_party_abbreviation_null] = 1
      else
        ransack_params[:elections_party_abbreviation_eq] = params[:party].upcase
      end
    end
    if ransack_params.blank?
      @legislators = Legislator.includes({elections: [:party, :ad], legislator_committees: [:committee, {ad_session: :ad}]}).has_records.offset(params[:offset]).limit(limit)
      @legislators_count = Legislator.has_records.length
    else
      @legislators = Legislator.includes({elections: [:party, :ad], legislator_committees: [:committee, {ad_session: :ad}]}).ransack(ransack_params).result(distinct: true).has_records
        .offset(params[:offset]).limit(limit)
      @legislators_count = Legislator.ransack(ransack_params).result(distinct: true).has_records.length
    end
    respond_with(@legislators, @legislators_count)
  end

  swagger_api :show do
    summary '單一立委'
    notes '回應單一立委資訊'
    param :path, :id, :integer, :optional, "立委 Id"
    response :ok, "Success", :APILegislatorShow
    response :not_found
  end

  def show
    @legislator = Legislator.includes({elections: [:party, :ad], legislator_committees: [:committee, {ad_session: :ad}]}).find(params[:id])
    respond_with(@legislator)
  end

  swagger_api :entries do
    summary '立委新聞列表'
    notes '回應、查詢立委新聞資訊'
    param :query, :query, :string, :optional, "查詢新聞標題或內文"
    param :query, :limit, :integer, :optional, "一次顯示多少筆"
    param :query, :offset, :integer, :optional, "從第幾筆開始顯示"
    response :ok, "Success", :APILegislatorEntries
  end

  def entries
    limit = params[:limit].blank? ? 10 : params[:limit]
    ransack_params = {}
    ransack_params[:title_or_content_cont] = params[:query] if params[:query]
    if ransack_params.blank?
      @entries = @legislator.entries.includes(legislators: :elections).published.offset(params[:offset]).limit(limit)
      @entries_count = @legislator.entries.published.count
    else
      @entries = @legislator.entries.includes(legislators: :elections).ransack(ransack_params).result(distinct: true)
        .published.offset(params[:offset]).limit(limit)
      @entries_count = @legislator.entries.ransack({title_or_content_cont: params[:query]}).result(distinct: true)
        .published.count
    end
    respond_with(@entries, @entries_count)
  end

  swagger_api :interpellations do
    summary '立委質詢列表'
    notes '回應、查詢立委質詢資訊'
    param :query, :query, :string, :optional, "查詢質詢標題、內文或會議資訊"
    param :query, :limit, :integer, :optional, "一次顯示多少筆"
    param :query, :offset, :integer, :optional, "從第幾筆開始顯示"
    response :ok, "Success", :APILegislatorInterpellations
  end

  def interpellations
    limit = params[:limit].blank? ? 10 : params[:limit]
    ransack_params = {}
    ransack_params[:title_or_content_or_meeting_description_cont] = params[:query] if params[:query]
    if ransack_params.blank?
      @interpellations = @legislator.interpellations.includes(:committee, ad_session: :ad, legislators: :elections).published.offset(params[:offset]).limit(limit)
      @interpellations_count = @legislator.interpellations.published.count
    else
      @interpellations = @legislator.interpellations.includes(:committee, :ad_session, legislators: :elections).ransack(ransack_params).result(distinct: true)
        .published.offset(params[:offset]).limit(limit)
      @interpellations_count = @legislator.interpellations.ransack(ransack_params).result(distinct: true)
        .published.count
    end
    respond_with(@interpellations, @interpellations_count)
  end

  swagger_api :videos do
    summary '立委影片列表'
    notes '回應、查詢立委影片資訊'
    param :query, :query, :string, :optional, "查詢影片標題、內文或會議資訊"
    param :query, :limit, :integer, :optional, "一次顯示多少筆"
    param :query, :offset, :integer, :optional, "從第幾筆開始顯示"
    response :ok, "Success", :APILegislatorVideos
  end

  def videos
    limit = params[:limit].blank? ? 10 : params[:limit]
    ransack_params = {}
    ransack_params[:title_or_content_or_meeting_description_cont] = params[:query] if params[:query]
    if ransack_params.blank?
      @videos = @legislator.videos.includes(:committee, ad_session: :ad, legislators: :elections).published.offset(params[:offset]).limit(limit)
      @videos_count = @legislator.videos.published.count
    else
      @videos = @legislator.videos.includes(:committee, ad_session: :ad, legislators: :elections).ransack(ransack_params).result(distinct: true)
        .published.offset(params[:offset]).limit(limit)
      @videos_count = @legislator.videos.ransack({title_or_content_or_meeting_description_cont: params[:query]}).result(distinct: true)
        .published.count
    end
    respond_with(@videos, @videos_count)
  end

  swagger_model :APILegislatorIndex do
    description "Legislator index structure"
    property :count, :integer, :required, "立委數"
    property :legislators, :array, :required, "立委列表", items: { '$ref' => :Legislator }
    property :status, :string, :required, "狀態"
  end

  swagger_model :APILegislatorShow do
    description "Legislator show structure"
    property :legislator, nil, :required, "立委", '$ref' => :Legislator
    property :status, :string, :required, "狀態"
  end

  swagger_model :APILegislatorEntries do
    description "Legislator entries structure"
    property :count, :integer, :required, "新聞數"
    property :entries, :array, :required, "新聞列表", items: { '$ref' => :Entry }
    property :status, :string, :required, "狀態"
  end

  swagger_model :APILegislatorInterpellations do
    description "Legislator interpellations structure"
    property :count, :integer, :required, "質詢數"
    property :interpellations, :array, :required, "質詢列表", items: { '$ref' => :Interpellation }
    property :status, :string, :required, "狀態"
  end

  swagger_model :APILegislatorVideos do
    description "Legislator videos structure"
    property :count, :integer, :required, "影片數"
    property :videos, :array, :required, "影片列表", items: { '$ref' => :Video }
    property :status, :string, :required, "狀態"
  end

  swagger_model :Legislator do
    description "立委"
    property :id, :integer, :required, "立委 Id"
    property :name, :string, :required, "立委名稱"
    property :image, :string, :required, "立委圖片"
    property :in_office, :boolean, :required, "在職與否"
    property :fb_link, :string, :required, "立委FB連結"
    property :wiki_link, :string, :required, "立委Wiki連結"
    property :musou_link, :string, :required, "國會無雙連結"
    property :ccw_link, :string, :required, "公督盟連結"
    property :ivod_link, :string, :required, "IVOD連結"
    property :party, nil, :required, "政黨", '$ref' => :Party
    property :elections, :array, :required, "選舉", items: { '$ref' => :Election }
    property :committees, :array, :required, "曾參與之委員會", items: { '$ref' => :Committee }
  end

  swagger_model :Party do
    description "政黨"
    property :id, :integer, :required, "政黨 Id"
    property :name, :string, :required, "政黨名稱"
    property :abbreviation, :string, :required, "政黨縮寫（無黨籍為null）"
    property :image, :string, :required, "政黨名稱"
  end

  swagger_model :Election do
    description "選舉"
    property :id, :integer, :required, "選舉 Id"
    property :constituency, :string, :required, "選區名稱"
    property :party, nil, :required, "政黨", '$ref' => :Party
    property :ad, nil, :required, "屆次", '$ref' => :Ad
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

  swagger_model :Committee do
    description "委員會"
    property :id, :integer, :required, "委員會 Id"
    property :name, :string, :required, "委員會名稱"
    property :convener, :boolean, :required, "是否為召委"
    property :ad_session, nil, :required, "參與之會期", '$ref' => :AdSession
  end

  swagger_model :SimpleLegislator do
    description "立委"
    property :id, :integer, :required, "立委 Id"
    property :name, :string, :required, "立委名稱"
    property :image, :string, :required, "立委圖片"
    property :party, nil, :required, "政黨", '$ref' => :Party
  end

  swagger_model :SimpleCommittee do
    description "委員會"
    property :id, :integer, :required, "委員會 Id"
    property :name, :string, :required, "委員會名稱"
  end

  swagger_model :Entry do
    description "新聞"
    property :legislators, :array, :required, "立委列表", items: { '$ref' => :SimpleLegislator }
    property :id, :integer, :required, "新聞 Id"
    property :title, :string, :required, "新聞標題"
    property :content, :text, :required, "新聞內文"
    property :source_url, :string, :required, "新聞來源網址"
    property :source_name, :string, :required, "新聞來源名稱"
    property :date, :date, :required, "新聞日期"
    property :created_at, :datetime, :required, "建立時間"
    property :updated_at, :datetime, :required, "更新時間"
  end

  swagger_model :Interpellation do
    description "質詢"
    property :legislators, :array, :required, "立委列表", items: { '$ref' => :SimpleLegislator }
    property :ad_session, nil, :required, "會期資料", '$ref' => :AdSession
    property :committee, nil, :required, '委員會資料', '$ref' => :SimpleCommittee
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

  swagger_model :Video do
    description "影片"
    property :legislators, :array, :required, "立委列表", items: { '$ref' => :SimpleLegislator }
    property :ad_session, nil, :required, "會期資料", '$ref' => :AdSession
    property :committee, nil, :optional, '委員會資料', '$ref' => :SimpleCommittee
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

  private

  def set_legislator
    @legislator = params[:id] ? Legislator.find(params[:id]) : Legislator.new(legislator_params)
  end
end