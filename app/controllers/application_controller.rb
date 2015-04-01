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
    if url.blank?
      return nil
    end
    page_content = $redis.get(url)
    unless page_content
      page_content = open(URI.parse(url)).read
      $redis.set(url, page_content)
      $redis.expire(url, 1.day.to_i)
    end
    return page_content
  end

  def parse_page_info(count, current_page = 1, per = 10)
    current_page = current_page.to_i
    count = count.to_i
    per = per.to_i
    total_page = (count / per) + 1
    if current_page < 1
      current_page = 1
    elsif current_page > total_page
      current_page = total_page
    end
    offset = (current_page - 1) * per
    low_pages = [1, 2, 3, 4]
    high_pages = [(total_page - 3), (total_page - 2), (total_page - 1), total_page]
    current_pages = [(current_page - 3), (current_page - 2), (current_page - 1), current_page, (current_page + 1), (current_page + 2), (current_page + 3)]
    results = low_pages + current_pages + high_pages
    puts 'results', results
    results = results.uniq
    results.sort!
    results.select! { |x| 1 <= x and x <=  total_page}
    return current_page, results
  end
end
