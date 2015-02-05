class VideosController < ApplicationController
  before_action :set_video, except: [:index, :new]
  before_action :authenticate_user!, except: [:show, :index]
  before_action :set_ip, only: [:create, :update]
  before_action :check_author, only: [:edit, :create, :update, :destroy]

  # GET /videos
  def index
    if params[:format] == "json"
      if params[:query]
        @videos = Video.where("title LIKE '%#{params[:query]}%' or content LIKE '%#{params[:query]}%'")
          .published.offset(params[:offset]).limit(params[:limit])
        @videos_count = Video.where("title LIKE '%#{params[:query]}%' or content LIKE '%#{params[:query]}%'")
          .published.count
      else
        @videos = Video.published.offset(params[:offset]).limit(params[:limit])
        @videos_count = Video.published.count
      end
    else
      if user_signed_in? and current_user.admin?
        @q = Video.search(params[:q])
        @videos = @q.result(:distinct => true).page(params[:page])
      else
        @q = Video.published.search(params[:q])
        @videos = @q.result(:distinct => true).page(params[:page])
      end
    end
    videos = @videos.clone.to_a
    @main_video = videos.shift
    @sub_videos = videos

    meta_legislators = Legislator.order_by_videos_created.limit(3)
    meta_keywords_list = meta_legislators.map { | l | "#{l.name}影片" }
    legislator_names = meta_legislators.map { | l | l.name }.join('、')
    if @main_video
      set_meta_tags({
        title: "最新立委影片",
        description: "最新影片由立委#{@main_video.legislators.first.name}出場。#{@main_video.title}",
        keywords: ["最新影片"] + meta_keywords_list,
        og: {
          type: 'article',
          description: "本期最新回報紀錄為#{legislator_names}",
          title: "最新立委影片調查報告",
          image: @main_video.image
        }
      })
    else
      set_meta_tags({
        title: "最新立委影片",
        description: "尚無影片。",
        keywords: ["最新影片"] + meta_keywords_list,
        og: {
          type: 'article',
          description: "本期最新回報紀錄為#{legislator_names}",
          title: "最新立委影片調查報告"
        }
      })
    end
    respond_to do |format|
      format.html
      format.json { render :json => {
          status: "success",
          videos: JSON.parse(
            @videos.to_json({include: {
              legislators: {
                include: { party: {except: [:created_at, :updated_at]} },
                except: [:description, :now_party_id, :created_at, :updated_at] },
              ad_session: { except: [:created_at, :updated_at] },
              committee: { except: [:created_at, :updated_at] }
            }, except: [:user_id, :user_ip, :published]})
          ),
          count: @videos_count
        },
        callback: params[:callback]
      }
    end
  end

  # GET /videos/1
  def show
    unless @video.published
      if user_signed_in? and current_user.admin?
      else
        not_found
      end
    end

    set_meta_tags({
      title: [@video.legislators.first.name, @video.title],
      description: @video.title,
      keywords: [@video.legislators.first.name, "#{@video.legislators.first.name}影片調查"],
      og: {
        type: 'video.tv_show',
        description: @video.title,
        title: "#{@video.legislators.first.name} － #{@video.title}",
        image: @video.image
      }
    })
    respond_to do |format|
      format.html
      format.json { render :json => {
        status: "success",
        video: JSON.parse(@video.to_json({
        include: {
          legislators: {
            include: { party: {except: [:created_at, :updated_at]} },
            except: [:description, :now_party_id, :created_at, :updated_at] },
          ad_session: { except: [:created_at, :updated_at] },
          committee: { except: [:created_at, :updated_at] }
            }, except: [:user_id, :user_ip, :published]}
          ))
        }, callback: params[:callback]
      }
    end
  end

  # GET /videos/new
  def new
    @video = Video.new
    set_meta_tags({
      title: "回報立委影片片段紀錄",
      og: {
        title: "回報立委影片片段紀錄"
      }
    })
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
      if user_signed_in? and current_user.admin?
        params.require(:video).permit(:title, :content, {:legislator_ids => []}, {:keyword_ids => []},
          :user_id, :ivod_url, :committee_id, :meeting_description, :date, :youtube_url, :source_url,
          :source_name, :published, :time_start, :time_end, :target, :video_type)
      else
        params.require(:video).permit(:title, :content, {:legislator_ids => []}, {:keyword_ids => []},
          :user_id, :ivod_url, :committee_id, :meeting_description, :date, :youtube_url, :source_url,
          :source_name, :time_start, :time_end, :target, :video_type)
      end
    end

    def set_ip
      if request.env['HTTP_CF_CONNECTING_IP']
        @video.user_ip = request.env['HTTP_CF_CONNECTING_IP']
      else
        @video.user_ip = request.env['REMOTE_ADDR']
      end
    end

    def check_author
      unless current_user == @video.user or current_user.admin?
        redirect_to video_path(@video)
      end
    end
end
