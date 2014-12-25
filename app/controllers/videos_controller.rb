class VideosController < ApplicationController
  before_action :set_video, except: [:index, :new]
  before_action :authenticate_user!, except: [:show, :index]
  before_action :set_ip, only: [:create, :update]

  # GET /videos
  def index
    if user_signed_in? and current_user.admin?
      @q = Video.search(params[:q])
    else
      @q = Video.published.search(params[:q])
    end
    @videos = @q.result(:distinct => true).page(params[:page])
    videos = @videos.to_a
    @main_video = videos.shift
    @sub_videos = videos
  end

  # GET /videos/1
  def show
    unless @video.published
      if user_signed_in? and current_user.admin?
      else
        not_found
      end
    end
  end

  # GET /videos/new
  def new
    @video = Video.new
  end

  # GET /videos/1/edit
  def edit
    unless @video.published
      if user_signed_in? and current_user.admin?
      else
        not_found
      end
    end
  end

  # POST /videos
  def create
    if @video.save
        redirect_to @video, notice: '影片建立成功'
    else
      render :new
    end
  end

  # PATCH/PUT /videos/1
  def update
    if @video.update(video_params)
      redirect_to @video, notice: '影片更新成功'
    else
      render :edit
    end
  end

  # DELETE /videos/1
  def destroy
    @video.destroy
    redirect_to videos_url, notice: '影片已刪除'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_video
      @video = params[:id] ? Video.find(params[:id]) : Video.new(video_params)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def video_params
      params.require(:video).permit(:title, :content, {:legislator_ids => []}, {:keyword_ids => []},
        :user_id, :ivod_url, :committee_id, :meeting_description, :date, :youtube_url, :source_url,
        :source_name, :published, :time_start, :time_end, :target, :video_type)
    end

    def set_ip
      @video.user_ip = request.env['REMOTE_HOST']
    end
end
