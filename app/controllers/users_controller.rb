class UsersController < ApplicationController
  before_action :set_user, except: [:index, :new]
  before_action :authenticate_user!
  before_action :require_admin

  # GET /admin/users
  def index
    @users = User.all.page params[:page]
  end

  # GET /admin/users/1
  def show
  end

  # GET /admin/users/1/edit
  def edit
  end

  # GET /admin/users/1/confirm
  def confirm
    unless @user.confirmed?
      @user.confirm!
      redirect_to users_url, notice: '會員成功認證'
    end
  end

  # PATCH/PUT /admin/users/1
  def update
    if @user.update(user_params)
      redirect_to users_url, notice: '會員成功更新'
    else
      render :edit
    end
  end

  # DELETE /admin/users/1
  def destroy
    @user.destroy
    redirect_to users_url, notice: '會員已被刪除'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = params[:id] ? User.find(params[:id]) : User.new(user_params)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:admin)
    end
end