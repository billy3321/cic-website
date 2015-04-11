class InterpellationsController < ApplicationController
  before_action :set_interpellation, except: [:index, :new]
  before_action :authenticate_user!, except: [:show, :index]
  before_action :set_ip, only: [:create, :update]
  before_action :check_author, only: [:edit, :update, :destroy]

  # GET /interpellations
  def index
    if params[:format] == "json"
      if params[:query]
        @interpellations = Interpellation.where("title LIKE '%#{params[:query]}%' or content LIKE '%#{params[:query]}%'")
          .published.offset(params[:offset]).limit(params[:limit])
        @interpellations_count = Interpellation.where("title LIKE '%#{params[:query]}%' or content LIKE '%#{params[:query]}%'")
          .published.count
      else
        @interpellations = Interpellation.published.offset(params[:offset]).limit(params[:limit])
        @interpellations_count = Interpellation.published.count
      end
    else
      if user_signed_in? and current_user.admin?
        @q = Interpellation.search(params[:q])
        @interpellations = @q.result(:distinct => true).page(params[:page])
      else
        @q = Interpellation.published.search(params[:q])
        @interpellations = @q.result(:distinct => true).page(params[:page])
      end
    end
    interpellations = @interpellations.clone.to_a
    @main_interpellation = interpellations.shift
    @sub_interpellations = interpellations

    meta_legislators = Legislator.order_by_interpellations_created.limit(3)
    meta_keywords_list = meta_legislators.map { | l | "#{l.name}質詢" }
    legislator_names = meta_legislators.map { | l | l.name }.join('、')
    if @main_interpellation
      set_meta_tags({
        title: "最新立委質詢",
        description: "最新質詢由立委#{@main_interpellation.legislators.first.name}出場。#{@main_interpellation.title}",
        keywords: ["最新質詢"] + meta_keywords_list,
        og: {
          type: 'article',
          description: "本期最新回報紀錄為#{legislator_names}",
          title: "最新立委質詢調查報告"
        }
      })
    else
      set_meta_tags({
        title: "最新立委質詢",
        description: "尚無立委質詢",
        keywords: ["最新質詢"] + meta_keywords_list,
        og: {
          type: 'article',
          description: "本期最新回報紀錄為#{legislator_names}",
          title: "最新立委質詢調查報告"
        }
      })
    end
    respond_to do |format|
      format.html
      format.json { render :json => {
          status: "success",
          interpellations: JSON.parse(
            @interpellations.to_json({include: {
              legislators: {
                include: { party: {except: [:created_at, :updated_at]} },
                except: [:description, :now_party_id, :created_at, :updated_at] },
              ad_session: { except: [:created_at, :updated_at] },
              ad: { except: [:created_at, :updated_at] },
              committee: { except: [:created_at, :updated_at] }
            }, except: [:user_id, :user_ip, :published]})
          ),
          count: @interpellations_count
        },
        callback: params[:callback]
      }
    end
  end

  # GET /interpellations/1
  def show
    unless @interpellation.published
      if user_signed_in? and current_user.admin?
      else
        not_found
      end
    end

    set_meta_tags({
      title: [@interpellation.legislators.first.name, @interpellation.title],
      description: @interpellation.title,
      keywords: [@interpellation.legislators.first.name, "#{@interpellation.legislators.first.name}質詢調查"],
      og: {
        type: 'article',
        description: @interpellation.title,
        title: "#{@interpellation.legislators.first.name} － #{@interpellation.title}",
        image: "/images/legislators/160x214/#{@interpellation.legislators.first.image}"
      }
    })
    respond_to do |format|
      format.html
      format.json { render :json => {
        status: "success",
        interpellation: JSON.parse(@interpellation.to_json({
        include: {
          legislators: {
            include: { party: {except: [:created_at, :updated_at]} },
            except: [:description, :now_party_id, :created_at, :updated_at] },
          ad_session: { except: [:created_at, :updated_at] },
          ad: { except: [:created_at, :updated_at] },
          committee: { except: [:created_at, :updated_at] }
          }, except: [:user_id, :user_ip, :published]}
          ))
        }, callback: params[:callback]
      }
    end
  end

  # GET /interpellations/new
  def new
    @interpellation = Interpellation.new
    set_meta_tags({
      title: "回報立委質詢文字紀錄",
      og: {
        title: "回報立委質詢文字紀錄"
      }
    })
  end

  # GET /interpellations/1/edit
  def edit
    unless @interpellation.published
      if current_user.admin?
      else
        not_found
      end
    end
  end

  # POST /interpellations
  def create
    if @interpellation.save
        redirect_to @interpellation, notice: '質詢建立成功'
    else
      render :new
    end
  end

  # PATCH/PUT /interpellations/1
  def update
    if @interpellation.update(interpellation_params)
      redirect_to @interpellation, notice: '質詢更新成功'
    else
      render :edit
    end
  end

  # DELETE /interpellations/1
  def destroy
    @interpellation.destroy
    redirect_to interpellations_url, notice: '質詢已刪除'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_interpellation
      @interpellation = params[:id] ? Interpellation.find(params[:id]) : Interpellation.new(interpellation_params)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def interpellation_params
      if user_signed_in? and current_user.admin?
        if @interpellation.blank? or @interpellation.new_record?
          params.require(:interpellation).permit(:title, :content, {:legislator_ids => []}, {:keyword_ids => []},
          :user_id, :ivod_url, :committee_id, :meeting_description, :date, :comment, :published, :time_start, :time_end, :target)
        else
          params.require(:interpellation).permit(:title, :content, {:legislator_ids => []}, {:keyword_ids => []},
          :ivod_url, :committee_id, :meeting_description, :date, :comment, :published, :time_start, :time_end, :target)
        end
      else
        params.require(:interpellation).permit(:title, :content, {:legislator_ids => []}, {:keyword_ids => []},
          :user_id, :ivod_url, :committee_id, :meeting_description, :date, :comment, :time_start, :time_end, :target)
      end
    end

    def set_ip
      if not current_user.admin? or @interpellation.new_record?
        if request.env['HTTP_CF_CONNECTING_IP']
          @interpellation.user_ip = request.env['HTTP_CF_CONNECTING_IP']
        else
          @interpellation.user_ip = request.env['REMOTE_ADDR']
        end
      end
    end

    def check_author
      unless current_user == @interpellation.user or current_user.admin?
        redirect_to interpellation_path(@interpellation)
      end
    end
end
