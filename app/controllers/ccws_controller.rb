class CcwsController < ApplicationController
  before_filter :set_ad_sessions
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
            committees: JSON.parse(
              ad_session.ccw_committee_data.to_json(
                include: [:committee ]
              )
            ),
            legislators: JSON.parse(
              ad_session.ccw_legislator_data.to_json(
                include: {legislator: {except: [:updated_at]}}
              )
            )}
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
    @yc_committee = Committee.where(kind: 'yc').first
    respond_to do |format|
      format.html
      format.json {render :json => {
        status: "success",
        ad_session: @ad_session,
        ccw: {
          citizen_score: @ad_session.ccw_citizen_score,
          committees: JSON.parse(
            @ad_session.ccw_committee_data.to_json(
                include: [:committee ]
              )
            ),
          legislators: JSON.parse(
            @ad_session.ccw_legislator_data.to_json(
                include: {legislator: {except: [:updated_at]}}
              )
            )
          },
        callback: params[:callback]
        }
      }
    end
  end

  def citizen_score
    @ccw_legislator_data = @ad_session.ccw_legislator_data.order(citizen_score: :desc)
  end

  private

  def set_ad_sessions
    @ad_sessions = AdSession.has_ccw_data
  end

  def set_ad_session
    @ad_session = AdSession.find(params[:id])
  end
end