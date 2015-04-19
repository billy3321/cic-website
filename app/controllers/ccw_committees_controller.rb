class CcwCommitteesController < ApplicationController
  before_filter :find_ad_session, :set_ad_sessions
  before_action :set_committee, except: [:index]

  def show
    @ccw_committee_datum = @committee.ccw_committee_data.where(ad_session_id: @ad_session.id).first
    @ccw_legislator_data = @committee.session_ccw_legislator_data(@ad_session.id)
  end

  def index
    @committees = @ad_session.sc_committees
    @committees.unshift(Committee.where(kind: 'yc').first)
  end

  private

  def find_ad_session
    @ad_session = AdSession.find(params[:id])
  end

  def set_ad_sessions
    @ad_sessions = AdSession.has_ccw_data
  end
  
  def set_committee
    @committee = Committee.find(params[:committee_id])
  end
end