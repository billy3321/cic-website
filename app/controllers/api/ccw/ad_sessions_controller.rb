class Api::Ccw::AdSessionsController < ApplicationController
  respond_to :json
  before_action :set_ad_session, only: [:show]

  def show
  end

  def index
    @ad_sessions = AdSession.includes(:ad).regulations
  end

  private

  def set_ad_session
    @ad_session = params[:id] ? AdSession.find(params[:id]) : AdSession.new(ad_session_params)
  end
end