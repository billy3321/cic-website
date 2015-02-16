class StaticPagesController < ApplicationController

  def home
    videos = Video.published.first(3)
    while videos.length < 3
      videos << nil
    end
    @main_video = videos.shift
    @sub_videos = videos
    @legislators = Legislator.order_by_videos_count.first(12)

    set_meta_tags({
      title: 'Congressional Investigation Corps',
      reverse: false,
      description: @main_video.try(:title),
      keywords: '國會調查兵團,cic,國會,立法委員,立委,國民黨,民進黨,台聯,親民黨,無黨籍',
      og: {
        title: "國會調查兵團 CIC",
        description: @main_video.try(:title)
      }
    })
  end

  def recent
    q = params[:q]
    @videos    = Video.published.search(title_or_content_or_meeting_description_cont: q).result.first(10)
    @entries   = Entry.published.search(title_or_content_cont: q).result.first(10)
    @questions = Question.published.search(title_or_content_or_meeting_description_cont: q).result.first(5)

    set_meta_tags({
      title: '國會調查兵團最新調查報告',
      description: @videos.first.try(:title),
      keywords: '國會調查兵團,cic,國會,立法委員,立委,國民黨,民進黨,台聯,親民黨,無黨籍',
      og: {
        title: "國會調查兵團最新調查報告",
        description: @videos.first.try(:title),
        image: @videos.first.try(:image)
      }
    })
  end

  def report
    set_meta_tags({
      title: '回報類型選擇',
      og: {
        description: @main_video.try(:title),
        title: "回報立委資訊"
      }
    })
  end

  def about
  end

  def faq
  end

  def service
  end

  def privacy
  end

  def tutorial
  end

  def opensource
  end

  def sitemap
    @legislators = Legislator.all
    @entries = Entry.all
    @questions = Question.all
    @videos = Video.all
  end
end
