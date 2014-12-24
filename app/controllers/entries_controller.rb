class EntriesController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  before_action :set_entry, except: [:index, :new]

  # GET /entries
  def index
    if user_signed_in? and current_user.admin?
      @q = Entry.search(params[:q])
    else
      @q = Entry.published.search(params[:q])
    end
    @entries = @q.result(:distinct => true).page(params[:page])
    entries = @entries.to_a
    @main_entry = entries.shift
    @sub_entries = entries
  end

  # GET /entries/1
  def show
    unless @entry.published
      if user_signed_in? and current_user.admin?
      else
        not_found
      end
    end
  end

  # GET /entries/entry
  def new
    @entry = Entry.new
  end

  # GET /entries/1/edit
  def edit
    unless @entry.published
      if user_signed_in? and current_user.admin?
      else
        not_found
      end
    end
  end

  # POST /entries
  def create
    @entry = Entry.new(entry_params)
    if @entry.save
        redirect_to @entry, notice: '新聞建立成功'
    else
      render :new
    end
  end

  # PATCH/PUT /entries/1
  def update
    if @entry.update(entry_params)
      redirect_to @entry, notice: '新聞更新成功'
    else
      render :edit
    end
  end

  # DELETE /entries/1
  def destroy
    @entry.destroy
    redirect_to entries_url, notice: '新聞已刪除'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_entry
      @entry = params[:id] ? Entry.find(params[:id]) : Entry.new(entry_params)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def entry_params
      params.require(:entry).permit(:title, :content, {:legislator_ids => []}, {:keyword_ids => []},
        :user_id, :date, :source_url, :published)
    end
end
