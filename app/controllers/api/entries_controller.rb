class Api::EntriesController < ApplicationController
  respond_to :json
  before_action :set_entry, only: [:show]

  swagger_controller :entries, 'Entries'

  swagger_api :index do
    summary '新聞列表'
    notes '回應、查詢新聞資訊'
    param :query, :query, :string, :optional, "查詢新聞標題或內文"
    param :query, :limit, :integer, :optional, "一次顯示多少筆"
    param :query, :offset, :integer, :optional, "從第幾筆開始顯示"
    response :ok, "Success", :APIEntryIndex
  end

  def index
    limit = params[:limit].blank? ? 10 : params[:limit]
    ransack_params = {}
    ransack_params[:title_or_content_cont] = params[:query] if params[:query]
    if ransack_params.blank?
      @entries = Entry.includes(legislators: :elections).published.offset(params[:offset]).limit(limit)
      @entries_count = Entry.published.count
    else
      @entries = Entry.includes(legislators: :elections).ransack(ransack_params).result(distinct: true)
        .published.offset(params[:offset]).limit(limit)
      @entries_count = Entry.ransack({title_or_content_cont: params[:query]}).result(distinct: true)
        .published.count
    end
    respond_with(@entries, @entries_count)
  end

  swagger_api :show do
    summary '單一新聞'
    notes '回應單一新聞資訊'
    param :path, :id, :integer, :optional, "新聞 Id"
    response :ok, "Success", :APIEntryShow
    response :not_found
  end

  def show
    respond_with(@entry)
  end

  swagger_model :APIEntryIndex do
    description "Entry index structure"
    property :count, :integer, :required, "新聞數"
    property :entries, :array, :required, "新聞列表", items: { '$ref' => :Entry }
    property :status, :string, :required, "狀態"
  end

  swagger_model :APIEntryShow do
    description "Entry show structure"
    property :entry, nil, :required, "新聞資料", '$ref' => :Entry
    property :status, :string, :required, "狀態"
  end

  swagger_model :Entry do
    description "新聞"
    property :legislators, :array, :required, "立委列表", items: { '$ref' => :Legislator }
    property :id, :integer, :required, "新聞 Id"
    property :title, :string, :required, "新聞標題"
    property :content, :text, :required, "新聞內文"
    property :source_url, :string, :required, "新聞來源網址"
    property :source_name, :string, :required, "新聞來源名稱"
    property :date, :date, :required, "新聞日期"
    property :created_at, :datetime, :required, "建立時間"
    property :updated_at, :datetime, :required, "更新時間"
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

  def set_entry
    @entry = params[:id] ? Entry.find(params[:id]) : Entry.new(entry_params)
  end
end