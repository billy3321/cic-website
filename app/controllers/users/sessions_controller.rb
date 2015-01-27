class Users::SessionsController < Devise::SessionsController
  skip_before_filter :require_no_authentication, only: [ :new, :create ]
# before_filter :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    if user_signed_in?
      if flash[:error] = "驗證碼輸入錯誤。" or flash[:recaptcha_error]
        flash[:error] = ""
        flash.delete(:recaptcha_error)
        destroy
      else
        redirect_to root_path
      end
    else
      super
    end
  end

  # POST /resource/sign_in
  def create
    captcha_result = verify_recaptcha
    if captcha_result
      super
    else
      if captcha_result
        flash.delete(:recaptcha_error)
      end
      build_resource()
      clean_up_passwords(resource)
      respond_with_navigational(resource) { render :new }
    end
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  protected

  # You can put the params you want to permit in the empty array.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.for(:sign_in) << :attribute
  # end

  def build_resource(hash=nil)
    self.resource = resource_class.new_with_session(hash || {}, session)
  end
end
