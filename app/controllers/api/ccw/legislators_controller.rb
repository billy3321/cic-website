class Api::Ccw::LegislatorsController < ApplicationController
  respond_to :json
  before_filter :find_ad_session
  before_action :set_legislator, only: [:show]

  def index
    limit = params[:limit].blank? ? 10 : params[:limit]
    ransack_params = {}
    ransack_params[:legislator_committee_legislator_name_cont] = params[:query] if params[:query]
    if params[:party]
      if params[:party] == 'null'
        ransack_params[:legislator_committee_legislator_elections_party_abbreviation_null] = 1
      else
        ransack_params[:legislator_committee_legislator_elections_party_abbreviation_eq] = params[:party].upcase
      end
    end
    if ransack_params.blank?
      @ccw_legislator_data = @ad_session.ccw_legislator_data.includes({legislator_committee: {legislator: {elections: [:party, :ad] }}}).offset(params[:offset]).limit(limit)
      @ccw_legislator_data_count = @ad_session.ccw_legislator_data.count
    else
      @ccw_legislator_data = @ad_session.ccw_legislator_data.includes({legislator_committee: {legislator: {elections: [:party, :ad] }}}).ransack(ransack_params).result(distinct: true)
        .offset(params[:offset]).limit(limit)
      @ccw_legislator_data_count = @ad_session.ccw_legislator_data.ransack(ransack_params).result(distinct: true).count
    end
    respond_with(@ccw_legislator_data, @ccw_legislator_data_count)
  end

  def show
    @ccw_legislator_datum = @legislator.get_session_ccw_data(@ad_session.id).first
    @sc_committee = @legislator.get_session_committee(@ad_session.id, 'sc').first
    @yc_committee = Committee.find(19)
    @sc_committee_datum = @sc_committee.ccw_committee_data.where(ad_session_id: @ad_session.id).first
    @yc_committee_datum = @yc_committee.ccw_committee_data.where(ad_session_id: @ad_session.id).first
    @ccw_citizen_score = @ad_session.ccw_citizen_score
    if @sc_committee_datum.blank? or @yc_committee_datum.blank? or @ccw_citizen_score.blank?
      @status = false
    else
      @status = true
    end
    respond_with(@ccw_legislator_datum, @sc_committee, @yc_committee, @ccw_citizen_score)
  end

  def citizen_score
    limit = params[:limit].blank? ? 10 : params[:limit]
    ransack_params = {}
    ransack_params[:legislator_committee_legislator_name_cont] = params[:query] if params[:query]
    if params[:party]
      if params[:party] == 'null'
        ransack_params[:legislator_committee_legislator_elections_party_abbreviation_null] = 1
      else
        ransack_params[:legislator_committee_legislator_elections_party_abbreviation_eq] = params[:party].upcase
      end
    end
    if ransack_params.blank?
      @ccw_legislator_data = @ad_session.ccw_legislator_data.includes({legislator_committee: {legislator: {elections: [:party, :ad] }}}).offset(params[:offset]).limit(limit)
      @ccw_legislator_data_count = @ad_session.ccw_legislator_data.count
    else
      @ccw_legislator_data = @ad_session.ccw_legislator_data.includes({legislator_committee: {legislator: {elections: [:party, :ad] }}}).ransack(ransack_params).result(distinct: true)
        .offset(params[:offset]).limit(limit)
      @ccw_legislator_data_count = @ad_session.ccw_legislator_data.ransack(ransack_params).result(distinct: true).count
    end
    @ccw_citizen_score = @ad_session.ccw_citizen_score
    respond_with(@ccw_legislator_data, @ccw_legislator_data_count)
  end

  private

  def find_ad_session
    @ad_session = AdSession.find(params[:ad_session_id])
  end

  def set_legislator
    @legislator = params[:id] ? Legislator.find(params[:id]) : Legislator.new(legislator_params)
  end
end