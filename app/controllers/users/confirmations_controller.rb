class Users::ConfirmationsController < Devise::ConfirmationsController
  # GET /resource/confirmation/new
  # def new
  #   super
  # end

  # POST /resource/confirmation
  def create
    captcha_result = verify_recaptcha
    if captcha_result
      super
    else
      if captcha_result
        flash.delete(:recaptcha_error)
      end
      build_resource
      respond_with_navigational(resource) { render :new }
    end
  end

  # GET /resource/confirmation?confirmation_token=abcdef
  # def show
  #   super
  # end

  # protected

  # The path used after resending confirmation instructions.
  # def after_resending_confirmation_instructions_path_for(resource_name)
  #   super(resource_name)
  # end

  # The path used after confirmation.
  # def after_confirmation_path_for(resource_name, resource)
  #   super(resource_name, resource)
  # end
  def build_resource(hash=nil)
    self.resource = resource_class.new_with_session(hash || {}, session)
  end
end
