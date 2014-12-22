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
    q = params[:q]
    #@videos    = Video.search(title_cont: q).result
    #@entries   = Entry.search(title_cont: q).result
    #@questions = Question.search(title_cont: q).result


    @q_videos = Video.search(params[:q_videos])
    @videos = Video.first(10)
    @q_entries = Entry.search(params[:q_entries])
    @entries = Entry.first(10)
    @q_questions = Question.search(params[:q_questions])
    @questions = Question.first(5)
  end

  def report
  end

  def about
  end
end
