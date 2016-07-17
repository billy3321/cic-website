class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session, unless: -> { request.format.json? }

  before_action :configure_devise_permitted_parameters, if: :devise_controller?

  def append_info_to_payload(payload)
    super
    payload[:request_id] = request.uuid
    payload[:user_id] = current_user.id if current_user
    if request.env['HTTP_CF_CONNECTING_IP']
      payload[:ip] = request.env['HTTP_CF_CONNECTING_IP']
    elsif request.env["HTTP_X_FORWARDED_FOR"]
      payload[:ip] = request.env["HTTP_X_FORWARDED_FOR"]
    else
      payload[:ip] = request.env['REMOTE_ADDR']
    end
  end

  protected

  def configure_devise_permitted_parameters
    registration_params = [:name, :email, :password, :password_confirmation, :agreement]

    if params[:action] == 'create'
      devise_parameter_sanitizer.permit(:sign_up) do |user|
        user.permit(registration_params)
      end
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

  def get_page(url)
    response = HTTParty.get(url)
    if response.code == 200
      return response.body
    else
      return false
    end
  end

  def get_cached_page(url, day = 7)
    if url.blank?
      return nil
    end
    if $redis.connected?
      page_content = $redis.get(url)
      unless page_content
        page_content = get_page(url)
        if page_content
          $redis.set(url, page_content)
          $redis.expire(url, day.days.to_i)
        end
      end
    else
      page_content = get_page(url)
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
    results = results.uniq
    results.sort!
    results.select! { |x| 1 <= x and x <=  total_page}
    return current_page, results
  end
end
