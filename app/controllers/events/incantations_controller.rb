class Events::IncantationsController < ApplicationController
  before_action :set_incantation
  before_action :set_legislator, only: [:result]
  before_action :set_legislators, only: [:show]

  def show
  end

  def result
    if @legislator == nil or @legislator.elections.last.ad.id != 9
      redirect_to events_incantation_path(@incantation)
    end
  end

  private

  def set_legislator
    @legislator = Legislator.exists?(params[:l]) ? Legislator.find(params[:l]) : nil
  end

  def set_legislators
    @legislators = Ad.find(9).legislators
  end

  def set_incantation
    @incantation = params[:id] ? Incantation.find(params[:id]) : nil
  end
end