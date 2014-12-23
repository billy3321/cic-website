class LegislatorsController < ApplicationController
  before_action :set_legislator, except: [:index, :new]

  # GET /legislators
  def index
    @q = Legislator.search(params[:q])
    @legislators = @q.result(:distinct => true).page params[:page]
  end

  # GET /legislators/1
  def show
  end

  # GET /legislators/1/entries
  def entries
    @entries = @legislator.entries
  end

  # GET /legislators/1/questions
  def questions
    @questions = @legislator.questions
  end

  # GET /legislators/1/videos
  def videos
    @videos = @legislator.videos
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
