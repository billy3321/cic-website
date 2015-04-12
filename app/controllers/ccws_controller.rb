class CcwsController < ApplicationController
  before_action :set_ad_session, except: [:index]

  def index
    if params[:format] == 'json'
      @ad_sessions = AdSession.has_ccw_data.offset(params[:offset]).limit(params[:limit])
      @ccws = []
      @ad_sessions.each do |ad_session|
        result = {
          ad_session: ad_session,
          ccw: {
            citizen_score: ad_session.ccw_citizen_score,
            committees: ad_session.ccw_committee_data.to_json(
                include: [:committee ]
              ),
            legislators: ad_session.ccw_legislator_data.to_json(
                include: {legislator: {except: [:updated_at]}}
              )
            }
          }
        @ccws << result
      end
      @ad_sessions_count = AdSession.has_ccw_data.length
    else
      @ad_sessions = AdSession.has_ccw_data
    end
    respond_to do |format|
      format.html
      format.json { 
        render :json => {
          status: "success",
          ccws: @ccws,
          count: @ad_sessions_count,
          callback: params[:callback]
        }
      }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json {render :json => {
        status: "success",
        ad_session: @ad_session,
        ccw: {
          citizen_score: @ad_session.ccw_citizen_score,
          committees: @ad_session.ccw_committee_data.to_json(
              include: [:committee ]
            ),
          legislators: @ad_session.ccw_legislator_data.to_json(
              include: {legislator: {except: [:updated_at]}}
            )
          },
        callback: params[:callback]
        }
      }
    end
  end

  private

  def set_ad_session
    @ad_session = AdSession.find(params[:id])
  end
end