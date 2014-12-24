class LegislatorsController < ApplicationController
  before_action :set_legislator, except: [:index, :new]

  # GET /legislators
  def index
    @q = Legislator.search(params[:q])
    @legislators = @q.result(:distinct => true).all
    @parties = Party.all
  end

  # GET /legislators/1
  def show
    @videos = @legislator.videos.published.first(5)
    @main_video = @videos.shift
    @sub_videos = @videos
    @entries = @legislator.entries.published.first(10)
    @questions = @legislator.questions.published.first(5)
  end

  # GET /legislators/1/entries
  def entries
    @entries = @legislator.entries.published.page(params[:page])
    entries = @entries.to_a
    @main_entry = entries.shift
    @sub_entries = entries
  end

  # GET /legislators/1/questions
  def questions
    @questions = @legislator.questions.published.page(params[:page])
    questions = @questions.to_a
    @main_question = questions.shift
    @sub_questions = questions
  end

  # GET /legislators/1/videos
  def videos
    @videos = @legislator.videos.published.page(params[:page])
    videos = @videos.to_a
    @main_video = videos.shift
    @sub_video = videos
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
