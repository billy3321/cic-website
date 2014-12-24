class StaticPagesController < ApplicationController
  def home
    videos = Video.order(created_at: :desc).first(3)
    while videos.length < 3
      videos << nil
    end
    @main_video = videos.shift
    @sub_videos = videos
    @legislators = Legislator.has_records.first(12)
  end

  def recent
    q = params[:q]
    @videos    = Video.published.search(title_or_content_or_meeting_description_cont: q).result.first(10)
    @entries   = Entry.published.search(title_or_content_cont: q).result.first(10)
    @questions = Question.published.search(title_or_content_or_meeting_description_cont: q).result.first(5)
  end

  def report
  end

  def about
  end
end
