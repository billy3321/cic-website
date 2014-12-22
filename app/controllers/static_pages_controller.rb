class StaticPagesController < ApplicationController
  def home
    videos = Video.order(created_at: :desc).first(3)
    while videos.length < 3
      videos << nil
    end
    @main_video = videos.shift
    @sub_videos = videos
    @legislators = Legislator.order_by_all_count.first(12)
  end

  def recent
  end

  def report
  end

  def about
  end
end
