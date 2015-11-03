class Api::LegislatorsController < ApplicationController
  respond_to :json
  before_action :set_legislator, except: [:index]

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

  private

  def set_legislator
    @legislator = params[:id] ? Legislator.find(params[:id]) : Legislator.new(legislator_params)
  end
end