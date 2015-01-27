class Users::RegistrationsController < Devise::RegistrationsController
# before_filter :configure_sign_up_params, only: [:create]
# before_filter :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    if session[:omniauth] == nil #OmniAuth
      captcha_result = verify_recaptcha
      if captcha_result && params[:user][:agreement] == "1"
        super
        session[:omniauth] = nil unless @user.new_record? #OmniAuth
      else
        build_resource(sign_up_params)
        clean_up_passwords(resource)
        if captcha_result
          flash.delete(:recaptcha_error)
        end
        if params[:user][:agreement] == "0"
          flash.now[:alert] = "請閱讀並同意使用條款。"
        end
        #use render :new for 2.x version of devise
        render :new
      end
    else
      super
      session[:omniauth] = nil unless @user.new_record? #OmniAuth
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  def update
    captcha_result = verify_recaptcha
    if captcha_result
      super
    else
      flash.delete(:recaptcha_error)
      build_resource
      clean_up_passwords(resource)
      respond_with_navigational(resource) { render :edit }
    end
  end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # You can put the params you want to permit in the empty array.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.for(:sign_up) << :attribute
  # end

  # You can put the params you want to permit in the empty array.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.for(:account_update) << :attribute
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
