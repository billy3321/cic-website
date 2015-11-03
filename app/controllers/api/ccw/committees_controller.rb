class Api::Ccw::CommitteesController < ApplicationController
  respond_to :json
  before_filter :find_ad_session
  before_action :set_committee, only: [:show]

  def index
    @ccw_committee_data = CcwCommitteeDatum.where(ad_session_id: @ad_session.id)
  end

  def show
    @ccw_committee_datum = @committee.ccw_committee_data.where(ad_session_id: @ad_session.id).first
    ccw_legislator_data_array = @committee.session_ccw_legislator_data(@ad_session.id)
    @ccw_legislator_data = CcwLegislatorDatum.includes(:legislator_committee).where(id: ccw_legislator_data_array.map(&:id))
  end

  private

  def find_ad_session
    @ad_session = AdSession.find(params[:ad_session_id])
  end

  def set_committee
    @committee = params[:id] ? Committee.find(params[:id]) : Committee.new(committee_params)
  end
end