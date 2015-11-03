class Api::EntriesController < ApplicationController
  respond_to :json
  before_action :set_entry, only: [:show]

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

  def show
    respond_with(@entry)
  end

  private

  def set_entry
    @entry = params[:id] ? Entry.find(params[:id]) : Entry.new(entry_params)
  end
end