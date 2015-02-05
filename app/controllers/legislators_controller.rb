class LegislatorsController < ApplicationController
  before_action :set_legislator, except: [:index, :new, :no_record, :has_records]

  # GET /legislators
  def index
    if params[:format] == "json"
      if params[:query]
        @legislators = Legislator.where("name LIKE '%#{params[:query]}%'").offset(params[:offset]).limit(params[:limit])
        @legislators_count = Legislator.where("name LIKE '%#{params[:query]}%'").count
      else
        @legislators = Legislator.offset(params[:offset]).limit(params[:limit])
        @legislators_count = Legislator.all.count
      end
    else
      @q = Legislator.search(params[:q])
      @legislators = @q.result(:distinct => true).all
    end
    @parties = Party.all

    set_meta_tags({
      title: '立委列表',
      description: '看看現任立委在國會殿堂的表現吧！',
      keywords: '立法委員,立委,國民黨,民進黨,台聯,親民黨,無黨籍,國會委員',
      og: {
        type: 'website',
        title: '國會立委列表',
        description: '看看現任立委在國會殿堂的表現吧！'
      }
    })

    respond_to do |format|
      format.html
      format.json {render :json => {
        status: "success",
        legislators: JSON.parse(@legislators.to_json(
          except: [:description, :now_party_id, :created_at, :updated_at],
          include: {party: {except: [:created_at, :updated_at]}
          })),
        count: @legislators_count},
        callback: params[:callback]
      }
    end
  end

  # GET /legislators/no_record
  def no_record
    if params[:format] == "json"
      if params[:query]
        @legislators = Legislator.where("name LIKE '%#{params[:query]}%'").has_no_record.offset(params[:offset]).limit(params[:limit])
        @legislators_count = Legislator.where("name LIKE '%#{params[:query]}%'").has_no_record.length
      else
        @legislators = Legislator.has_no_record.offset(params[:offset]).limit(params[:limit])
        @legislators_count = Legislator.has_no_record.length
      end
    else
      @q = Legislator.has_no_record.search(params[:q])
      @legislators = @q.result(:distinct => true).all
    end
    @parties = Party.all

    set_meta_tags({
      title: '立委列表',
      description: '看看現任立委在國會殿堂的表現吧！',
      keywords: '立法委員,立委,國民黨,民進黨,台聯,親民黨,無黨籍,國會委員',
      og: {
        type: 'website',
        title: '國會立委列表',
        description: '看看現任立委在國會殿堂的表現吧！'
      }
    })
    respond_to do |format|
      format.html
      format.json {render :json => {
        status: "success",
        legislators: JSON.parse(@legislators.to_json(
          except: [:description, :now_party_id, :created_at, :updated_at],
          include: {party: {except: [:created_at, :updated_at]}
          })),
        count: @legislators_count
        },
        callback: params[:callback]
      }
    end
  end

  # GET /legislators/has_records
  def has_records
    if params[:format] == "json"
      if params[:query]
        @legislators = Legislator.where("name LIKE '%#{params[:query]}%'").has_records.offset(params[:offset]).limit(params[:limit])
        @legislators_count = Legislator.where("name LIKE '%#{params[:query]}%'").has_records.length
      else
        @legislators = Legislator.has_records.offset(params[:offset]).limit(params[:limit])
        @legislators_count = Legislator.has_records.length
      end
    else
      @q = Legislator.has_records.search(params[:q])
      @legislators = @q.result(:distinct => true).all
    end
    @parties = Party.all

    set_meta_tags({
      title: '立委列表',
      description: '看看現任立委在國會殿堂的表現吧！',
      keywords: '立法委員,立委,國民黨,民進黨,台聯,親民黨,無黨籍,國會委員',
      og: {
        type: 'website',
        title: '國會立委列表',
        description: '看看現任立委在國會殿堂的表現吧！'
      }
    })
    respond_to do |format|
      format.html
      format.json {render :json => {
        status: "success",
        legislators: JSON.parse(@legislators.to_json(
          except: [:associations_count, :description, :now_party_id, :created_at, :updated_at],
          include: {party: {except: [:created_at, :updated_at]}
          })),
        count: @legislators_count
        },
        callback: params[:callback]
      }
    end
  end

  # GET /legislators/1
  def show
    @videos = @legislator.videos.published.first(5)
    @main_video = @videos.shift
    @sub_videos = @videos
    @entries = @legislator.entries.published.first(10)
    @questions = @legislator.questions.published.first(5)

    set_meta_tags({
      title: "#{@legislator.name}調查報告",
      description: '看看現任立委在國會殿堂的表現吧！',
      keywords: "#{@legislator.name},#{@legislator.name}調查報告",
      og: {
        type: 'profile',
        description: "你知道#{@legislator.name}在國會的表現嗎？這裡是#{@legislator.name}的調查報告。",
        title: "#{@legislator.name}調查報告",
        image: "/images/legislators/160x214/#{@legislator.image}"
      }
    })

    respond_to do |format|
      format.html
      format.json {render :json => {
        status: "success",
        legislator: JSON.parse(@legislator.to_json(
        except: [:description, :now_party_id, :created_at, :updated_at],
        include: {
          party: {except: [:created_at, :updated_at]},
          elections: {except: [:created_at, :updated_at]},
          questions: {}, entries:{}, videos:{}
        }))},
        callback: params[:callback]
      }
    end
  end

  # GET /legislators/1/entries
  def entries
    if params[:format] == "json"
      if params[:query]
        @entries = @legislator.entries.where("title LIKE '%#{params[:query]}%' or content LIKE '%#{params[:query]}%'")
          .published.offset(params[:offset]).limit(params[:limit])
        @entries_count = @legislator.entries.where("title LIKE '%#{params[:query]}%' or content LIKE '%#{params[:query]}%'")
          .published.count
      else
        @entries = @legislator.entries.published.offset(params[:offset]).limit(params[:limit])
        @entries_count = @legislator.entries.published.count
      end
    else
      @entries = @legislator.entries.published.page(params[:page])
    end
    entries = @entries.clone.to_a
    @main_entry = entries.shift
    @sub_entries = entries

    set_meta_tags({
      title: "#{@legislator.name}新聞列表",
      description: @main_entry.try(:title),
      keywords: "#{@legislator.name},#{@legislator.name}新聞調查",
      og: {
        type: 'article',
        description: @main_entry.try(:title),
        title: "#{@legislator.name}新聞調查報告",
        image: "/images/legislators/160x214/#{@legislator.image}"
      }
    })
    respond_to do |format|
      format.html
      format.json { render :json => {
          status: "success",
          entries: JSON.parse(@entries.to_json({except: [:user_id, :user_ip, :published]})),
          count: @legislator.entries.published.count
        },
        callback: params[:callback]
      }
    end
  end

  # GET /legislators/1/questions
  def questions
    if params[:format] == "json"
      if params[:query]
        @questions = @legislator.questions.where("title LIKE '%#{params[:query]}%' or content LIKE '%#{params[:query]}%'")
          .published.offset(params[:offset]).limit(params[:limit])
        @questions_count = @legislator.questions.where("title LIKE '%#{params[:query]}%' or content LIKE '%#{params[:query]}%'")
          .published.count
      else
        @questions = @legislator.questions.published.offset(params[:offset]).limit(params[:limit])
        @questions_count = @legislator.questions.published.count
      end
    else
      @questions = @legislator.questions.published.page(params[:page])
    end
    questions = @questions.clone.to_a
    @main_question = questions.shift
    @sub_questions = @questions

    set_meta_tags({
      title: "#{@legislator.name}質詢列表",
      description: @main_question.try(:title),
      keywords: "#{@legislator.name},#{@legislator.name}質詢調查",
      og: {
        type: 'article',
        description: @main_question.try(:title),
        title: "#{@legislator.name}質詢調查報告",
        image: "/images/legislators/160x214/#{@legislator.image}"
      }
    })
    respond_to do |format|
      format.html
      format.json { render :json => {
          status: "success",
          questions: JSON.parse(
            @questions.to_json({include: {
              ad_session: { except: [:created_at, :updated_at] },
              committee: { except: [:created_at, :updated_at] }
            }, except: [:user_id, :user_ip, :published]})
          ),
          count: @questions_count
        },
        callback: params[:callback]
      }
    end

  end

  # GET /legislators/1/videos
  def videos
    if params[:format] == "json"
      if params[:query]
        @videos = @legislator.videos.where("title LIKE '%#{params[:query]}%' or content LIKE '%#{params[:query]}%'")
          .published.offset(params[:offset]).limit(params[:limit])
        @videos_count = @legislator.videos.where("title LIKE '%#{params[:query]}%' or content LIKE '%#{params[:query]}%'")
          .published.count
      else
        @videos = @legislator.videos.published.offset(params[:offset]).limit(params[:limit])
        @videos_count = @legislator.videos.published.count
      end
    else
      @videos = @legislator.videos.published.page(params[:page])
    end
    videos = @videos.clone.to_a
    @main_video = videos.shift
    @sub_videos = videos

    set_meta_tags({
      title: "#{@legislator.name}影片列表",
      description: @main_video.try(:title),
      keywords: "#{@legislator.name},#{@legislator.name}影片調查",
      og: {
        type: 'video.tv_show',
        description: @main_video.try(:title),
        title: "#{@legislator.name}影片調查報告",
        image: "/images/legislators/160x214/#{@legislator.image}"
      }
    })
    respond_to do |format|
      format.html
      format.json { render :json => {
          status: "success",
          videos: JSON.parse(
            @videos.to_json({include: {
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_legislator
      @legislator = params[:id] ? Legislator.find(params[:id]) : Legislator.new(legislator_params)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def legislator_params
      params.require(:legislator).permit()
    end
end
