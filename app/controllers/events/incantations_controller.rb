class Events::IncantationsController < ApplicationController
  before_action :set_incantation
  before_action :set_legislator, only: [:result]
  before_action :set_legislators, only: [:show]

  def show
    set_meta_tags({
      title: "#{@incantation.title}-天眼公民咒",
      description: "天眼公民咒，#{@incantation.title}，你要為誰貼咒？",
      keywords: "#{@incantation.title},天眼公民咒,公民廟口,國會調查兵團",
      og: {
        type: 'website',
        title: "#{@incantation.title}-天眼公民咒",
        description: "天眼公民咒，#{@incantation.title}，你要為誰貼咒？",
        image: "#{Setting.url.protocol}://#{Setting.url.host}/images/events/incantations/inc-0#{@incantation.id}-fb.gif",
        site_name: "國會調查兵團"
      },
      article: {
        author: "https://www.facebook.com/cictw/",
        publisher: "https://www.facebook.com/cictw/"
      },
      twitter: {
        image: "#{Setting.url.protocol}://#{Setting.url.host}/images/events/incantations/inc-0#{@incantation.id}-fb.gif"
      }
    })
  end

  def result
    if @legislator == nil or @legislator.elections.last.ad.id != 9
      redirect_to events_incantation_path(@incantation)
    end
    set_meta_tags({
      title: "#{@legislator.name}-#{@incantation.title}",
      description: "#{@legislator.name}聽我令：#{@incantation.word}",
      keywords: @legislator.name,
      og: {
        type: 'profile',
        title: "#{@legislator.name}-#{@incantation.title}",
        description: "#{@legislator.name}聽我令：#{@incantation.word}",
        image: "#{Setting.url.protocol}://#{Setting.url.host}/images/events/incantations/inc-0#{@incantation.id}-fb.gif",
        site_name: "國會調查兵團"
      },
      article: {
        author: "https://www.facebook.com/cictw/",
        publisher: "https://www.facebook.com/cictw/"
      },
      twitter: {
        image: "#{Setting.url.protocol}://#{Setting.url.host}/images/events/incantations/inc-0#{@incantation.id}-fb.gif"
      }
    })
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
