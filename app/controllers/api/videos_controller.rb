class Api::VideosController < ApplicationController
  respond_to :json
  before_action :set_video, only: [:show]

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

  def show
    respond_with(@video)
  end

  private

  def set_video
    @video = params[:id] ? Video.find(params[:id]) : Video.new(video_params)
  end
end