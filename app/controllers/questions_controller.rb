class QuestionsController < ApplicationController
  before_action :set_question, except: [:index, :new]

  # GET /questions
  def index
    @questions = Question.all.page params[:page]
  end

  # GET /questions/1
  def show
  end

  # GET /questions/new
  def new
    @question = Question.new
  end

  # GET /questions/1/edit
  def edit
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
      params.require(:question).permit(:title, :content, {:legislator_ids => []},
        :user_id, :ivod_url, :committee_id, :meeting_description, :date, :comment)
    end
end
