class CcwCommitteesController < ApplicationController
  before_filter :find_ad_session, :set_ad_sessions
  before_action :set_committee, except: [:index]

  def show
    @ccw_committee_datum = @committee.ccw_committee_data.where(ad_session_id: @ad_session.id).first
    @ccw_legislator_data = @committee.session_ccw_legislator_data(@ad_session.id)

    unless @committee.kind == 'yc'
      set_meta_tags({
        title: "#{@committee.name}出席率、質詢率比一比",
        description: "#{@committee.name}出席率、質詢率比一比！#{@committee.name}哪個立委的表現最好？",
        keywords: "#{@committee.name}立委出席率,出席率,#{@ad_session.ad.name}#{@ad_session.name}#{@committee.name}出席率",
        og: {
          type: 'article',
          title: "#{@committee.name}出席率、質詢率比一比",
          description: "#{@committee.name}出席率、質詢率比一比！#{@committee.name}哪個立委的表現最好？"
        }
      })
    else
      set_meta_tags({
        title: "#{@committee.name}出席率比一比",
        description: "#{@committee.name}出席率比一比！哪個立委在#{@committee.name}的出席率最高？所有立委平均出席率又是多少？",
        keywords: '立委院會出席率,委員會出席率,公民評鑑',
        og: {
          type: 'article',
          title: "#{@committee.name}出席率比一比",
          description: "#{@committee.name}出席率比一比！哪個立委在#{@committee.name}的出席率最高？所有立委平均出席率又是多少？"
        }
      })
    end
  end

  def index
    @committees = @ad_session.sc_committees
    @committees.unshift(Committee.where(kind: 'yc').first)
    @ccw_committee_data = @ad_session.ccw_committee_data.includes(:committee)

    set_meta_tags({
      title: '委員會出席率、質詢率比一比',
      description: '委員會出席率、質詢率比一比！哪個立委在委員會的出席率最高?哪個立委的質詢率最高？',
      keywords: "立委委員會出席率,出席率,#{@ad_session.ad.name}#{@ad_session.name}委員會出席率",
      og: {
        type: 'article',
        title: '委員會出席率、質詢率比一比',
        description: '委員會出席率、質詢率比一比！哪個立委在委員會的出席率最高?哪個立委的質詢率最高？'
      }
    })
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