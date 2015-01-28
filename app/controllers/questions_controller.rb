class QuestionsController < ApplicationController
  before_action :set_question, except: [:index, :new]
  before_action :authenticate_user!, except: [:show, :index]
  before_action :set_ip, only: [:create, :update]
  before_action :check_author, only: [:edit, :update, :destroy]

  # GET /questions
  def index
    if user_signed_in? and current_user.admin?
      @q = Question.search(params[:q])
    else
      @q = Question.published.search(params[:q])
    end
    @questions = @q.result(:distinct => true).page(params[:page])
    questions = @questions.to_a
    @main_question = questions.shift
    @sub_questions = questions

    meta_legislators = Legislator.order_by_questions_created.limit(3)
    meta_keywords_list = meta_legislators.map { | l | "#{l.name}質詢" }
    legislator_names = meta_legislators.map { | l | l.name }.join('、')
    if @main_question
      set_meta_tags({
        title: "最新立委質詢",
        description: "最新質詢由立委#{@main_question.legislators.first.name}出場。#{@main_question.title}",
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
  end

  # GET /questions/1
  def show
    unless @question.published
      if user_signed_in? and current_user.admin?
      else
        not_found
      end
    end

    set_meta_tags({
      title: [@question.legislators.first.name, @question.title],
      description: @question.title,
      keywords: [@question.legislators.first.name, "#{@question.legislators.first.name}質詢調查"],
      og: {
        type: 'article',
        description: @question.title,
        title: "#{@question.legislators.first.name} － #{@question.title}",
        image: "/images/legislators/160x214/#{@question.legislators.first.image}"
      }
    })
  end

  # GET /questions/new
  def new
    @question = Question.new
    set_meta_tags({
      title: "回報立委質詢文字紀錄",
      og: {
        title: "回報立委質詢文字紀錄"
      }
    })
  end

  # GET /questions/1/edit
  def edit
    unless @question.published
      if current_user.admin?
      else
        not_found
      end
    end
  end

  # POST /questions
  def create
    if @question.save
        redirect_to @question, notice: '質詢建立成功'
    else
      render :new
    end
  end

  # PATCH/PUT /questions/1
  def update
    if @question.update(question_params)
      redirect_to @question, notice: '質詢更新成功'
    else
      render :edit
    end
  end

  # DELETE /questions/1
  def destroy
    @question.destroy
    redirect_to questions_url, notice: '質詢已刪除'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_question
      @question = params[:id] ? Question.find(params[:id]) : Question.new(question_params)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def question_params
      if user_signed_in? and current_user.admin?
        params.require(:question).permit(:title, :content, {:legislator_ids => []}, {:keyword_ids => []},
          :user_id, :ivod_url, :committee_id, :meeting_description, :date, :comment, :published, :time_start, :time_end, :target)
      else
        params.require(:question).permit(:title, :content, {:legislator_ids => []}, {:keyword_ids => []},
          :user_id, :ivod_url, :committee_id, :meeting_description, :date, :comment, :time_start, :time_end, :target)
      end
    end

    def set_ip
      @question.user_ip = request.env['REMOTE_HOST']
    end

    def check_author
      unless current_user == @question.user or current_user.admin?
        redirect_to question_path(@question)
      end
    end
end
