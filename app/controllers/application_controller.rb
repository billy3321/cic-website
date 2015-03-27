class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session, unless: -> { request.format.json? }

  before_action :configure_devise_permitted_parameters, if: :devise_controller?



  protected

  def configure_devise_permitted_parameters
    registration_params = [:name, :email, :password, :password_confirmation, :agreement]

    if params[:action] == 'create'
      devise_parameter_sanitizer.for(:sign_up) {
        |u| u.permit(registration_params)
      }
    end
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  private

  def require_admin
    unless current_user.admin?
      begin
        redirect_to :back
      rescue ActionController::RedirectBackError
        redirect_to root_path
      end
    end
  end

  def get_cached_page(url)
    page_content = $redis.get(url)
    unless page_content
      page_content = open(URI.parse(url)).read
      $redis.set(url, page_content)
      $redis.expire(url, 1.day.to_i)
    end
    return page_content
  end
end
