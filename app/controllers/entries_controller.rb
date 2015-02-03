class EntriesController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  before_action :set_entry, except: [:index, :new]
  before_action :set_ip, only: [:create, :update]
  before_action :check_author, only: [:edit, :create, :update, :destroy]

  # GET /entries
  def index
    if user_signed_in? and current_user.admin?
      @q = Entry.search(params[:q])
    else
      @q = Entry.published.search(params[:q])
    end
    @entries = @q.result(:distinct => true).page(params[:page])
    entries = @entries.clone.to_a
    @main_entry = entries.shift
    @sub_entries = entries

    meta_legislators = Legislator.order_by_entries_created.limit(3)
    meta_keywords_list = meta_legislators.map { | l | "#{l.name}新聞" }
    legislator_names = meta_legislators.map { | l | l.name }.join('、')
    if @main_entry
      set_meta_tags({
        title: "最新立委新聞",
        description: "最新新聞由立委#{@main_entry.legislators.first.name}出場。#{@main_entry.title}",
        keywords: ["最新新聞"] + meta_keywords_list,
        og: {
          type: 'article',
          description: "本期最新回報紀錄為#{legislator_names}",
          title: "最新立委影片調查報告"
        }
      })
    else
      set_meta_tags({
        title: "最新立委新聞",
        description: "尚無新聞",
        keywords: ["最新新聞"] + meta_keywords_list,
        og: {
          type: 'article',
          description: "本期最新回報紀錄為#{legislator_names}",
          title: "最新立委影片調查報告"
        }
      })
    end
    respond_to do |format|
      format.html
      format.json { render :json => @entries,
        include: {
          legislators: {
            include: { party: {except: [:created_at, :updated_at]} },
            except: [:now_party_id, :created_at, :updated_at] }
        },
        callback: params[:callback]
      }
    end
  end

  # GET /entries/1
  def show
    unless @entry.published
      if user_signed_in? and current_user.admin?
      else
        not_found
      end
    end

    set_meta_tags({
      title: [@entry.legislators.first.name, @entry.title],
      description: @entry.title,
      keywords: [@entry.legislators.first.name, "#{@entry.legislators.first.name}新聞調查"],
      og: {
        type: 'article',
        description: @entry.title,
        title: "#{@entry.legislators.first.name} － #{@entry.title}",
        image: "/images/legislators/160x214/#{@entry.legislators.first.image}"
      }
    })
    respond_to do |format|
      format.html
      format.json { render :json => @entry,
        include: {
          legislators: {
            include: { party: {except: [:created_at, :updated_at]} },
            except: [:now_party_id, :created_at, :updated_at] }
        },
        callback: params[:callback]
      }
    end
  end

  # GET /entries/entry
  def new
    @entry = Entry.new
    set_meta_tags({
      title: "回報立委新聞紀錄",
      og: {
        title: "回報立委新聞紀錄"
      }
    })
  end

  # GET /entries/1/edit
  def edit
    unless @entry.published
      if user_signed_in? and current_user.admin?
      else
        not_found
      end
    end
  end

  # POST /entries
  def create
    if @entry.save
        redirect_to @entry, notice: '新聞建立成功'
    else
      render :new
    end
  end

  # PATCH/PUT /entries/1
  def update
    if @entry.update(entry_params)
      redirect_to @entry, notice: '新聞更新成功'
    else
      render :edit
    end
  end

  # DELETE /entries/1
  def destroy
    @entry.destroy
    redirect_to entries_url, notice: '新聞已刪除'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_entry
      @entry = params[:id] ? Entry.find(params[:id]) : Entry.new(entry_params)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def entry_params
      if user_signed_in? and current_user.admin?
        params.require(:entry).permit(:title, :content, {:legislator_ids => []}, {:keyword_ids => []},
          :user_id, :date, :source_name, :source_url, :published)
      else
        params.require(:entry).permit(:title, :content, {:legislator_ids => []}, {:keyword_ids => []},
          :user_id, :date, :source_name, :source_url)
      end
    end

    def set_ip
      if request.env['HTTP_CF_CONNECTING_IP']
        @entry.user_ip = request.env['HTTP_CF_CONNECTING_IP']
      else
        @entry.user_ip = request.env['REMOTE_ADDR']
      end
    end

    def check_author
      unless current_user == @entry.user or current_user.admin?
        redirect_to entry_path(@entry)
      end
    end
end
