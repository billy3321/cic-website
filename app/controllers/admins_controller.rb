class AdminsController < ApplicationController
  def entries
    @entries = Entry.all.page(params[:page])
  end

  def questions
    @questions = Question.all.page(params[:page])
  end

  def videos
    @videos = Video.all.page(params[:page])
  end

  def update_entries
    if params[:entry_ids]
      @entries = Entry.find(params[:entry_ids])
      published_ids = params[:published_ids]
      @entries.each do |e|
        if published_ids.include?(e.id.to_s)
          if e.published == false
            e.published = true
            e.save
          end
        else
          if e.published == true
            e.published = false
            e.save
          end
        end
      end
      flash[:notice] = "Updated entries!"
    end
    redirect_to '/admin/entries'
  end

  def update_questions
    if params[:question_ids]
      @questions = Question.find(params[:question_ids])
      published_ids = params[:published_ids]
      @questions.each do |q|
        if published_ids.include?(q.id.to_s)
          if q.published == false
            q.published = true
            q.save
          end
        else
          if q.published == true
            q.published = false
            q.save
          end
        end
      end
      flash[:notice] = "Updated questions!"
    end
    redirect_to '/admin/questions'
  end

  def update_videos
    if params[:video_ids]
      @videos = Video.find(params[:video_ids])
      published_ids = params[:published_ids]
      @videos.each do |v|
        if published_ids.include?(v.id.to_s)
          if v.published == false
            v.published = true
            v.save
          end
        else
          if v.published == true
            v.published = false
            v.save
          end
        end
      end
      flash[:notice] = "Updated videos!"
    end
    redirect_to '/admin/videos'
  end
end