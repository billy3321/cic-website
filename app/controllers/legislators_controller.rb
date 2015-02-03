class LegislatorsController < ApplicationController
  before_action :set_legislator, except: [:index, :new, :no_record, :has_record]

  # GET /legislators
  def index
    @q = Legislator.search(params[:q])
    @legislators = @q.result(:distinct => true).all
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
      format.json {render :json => @legislators,
        except: [:now_party_id, :created_at, :updated_at],
        include: {party: {except: [:created_at, :updated_at]}
        }
      }
    end
  end

  # GET /legislators/no_record
  def no_record
    @q = Legislator.has_no_record.search(params[:q])
    @legislators = @q.result(:distinct => true).all
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
      format.json {render :json => @legislators,
        except: [:now_party_id, :created_at, :updated_at],
        include: {party: {except: [:created_at, :updated_at]}
        }
      }
    end
  end

  # GET /legislators/has_record
  def has_record
    @q = Legislator.has_records.search(params[:q])
    @legislators = @q.result(:distinct => true).all
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
      format.json {render :json => @legislators,
        except: [:now_party_id, :created_at, :updated_at],
        include: {party: {except: [:created_at, :updated_at]}}}
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
      format.json {render :json => @legislator,
        except: [:now_party_id, :created_at, :updated_at],
        include: {
          party: {except: [:created_at, :updated_at]},
          elections: {except: [:created_at, :updated_at]},
          questions: {}, entries:{}, videos:{}
        }
      }
    end
  end

  # GET /legislators/1/entries
  def entries
    @entries = @legislator.entries.published.page(params[:page])
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
      format.json { render :json => @entries }
    end
  end

  # GET /legislators/1/questions
  def questions
    @questions = @legislator.questions.published.page(params[:page])
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
      format.json { render :json => @questions,
        include: {
          ad_session: { except: [:created_at, :updated_at] },
          committee: { except: [:created_at, :updated_at] }
          }
        }
    end

  end

  # GET /legislators/1/videos
  def videos
    @videos = @legislator.videos.published.page(params[:page])
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
      format.json { render :json => @videos,
        include: {
          ad_session: { except: [:created_at, :updated_at] },
          committee: { except: [:created_at, :updated_at] }
          }
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
