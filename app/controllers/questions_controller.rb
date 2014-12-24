class QuestionsController < ApplicationController
  before_action :set_question, except: [:index, :new]
  before_action :authenticate_user!, except: [:show, :index]

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
  end

  # GET /questions/1
  def show
    unless @question.published
      if user_signed_in? and current_user.admin?
      else
        not_found
      end
    end
  end

  # GET /questions/new
  def new
    @question = Question.new
  end

  # GET /questions/1/edit
  def edit
    unless @question.published
      if user_signed_in? and current_user.admin?
      else
        not_found
      end
    end
  end

  # POST /questions
  def create
    @question = Question.new(question_params)
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
      params.require(:question).permit(:title, :content, {:legislator_ids => []}, {:keyword_ids => []},
        :user_id, :ivod_url, :committee_id, :meeting_description, :date, :comment, :published)
    end
end
