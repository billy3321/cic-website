class Users::PasswordsController < Devise::PasswordsController
  # GET /resource/password/new
  # def new
  #   super
  # end

  # POST /resource/password
  def create
    if verify_recaptcha
      super
    else
      build_resource
      flash[:error] = "驗證碼輸入錯誤。"
      respond_with_navigational(resource) { render :new }
    end
  end

  # GET /resource/password/edit?reset_password_token=abcdef
  # def edit
  #   super
  # end

  # PUT /resource/password
  def update
    if verify_recaptcha
      super
    else
      build_resource
      flash[:error] = "驗證碼輸入錯誤。"
      respond_with_navigational(resource) { render :edit }
    end
  end

  # protected

  # def after_resetting_password_path_for(resource)
  #   super(resource)
  # end

  # The path used after sending reset password instructions
  # def after_sending_reset_password_instructions_path_for(resource_name)
  #   super(resource_name)
  # end
  def build_resource(hash=nil)
    self.resource = resource_class.new_with_session(hash || {}, session)
  end
end
