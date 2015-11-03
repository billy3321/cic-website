class Api::InterpellationsController < ApplicationController
  respond_to :json
  before_action :set_interpellation, only: [:show]

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

  def show
    respond_with(@interpellation)
  end

  private

  def set_interpellation
    @interpellation = params[:id] ? Interpellation.find(params[:id]) : Interpellation.new(interpellation_params)
  end
end