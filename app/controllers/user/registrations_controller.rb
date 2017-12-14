require "sign_up_parameter_sanitizer.rb"

class User::RegistrationsController < Devise::RegistrationsController
  include User::RegistrationsHelper

  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  def new
    @sign_up = SignUp.new
  end

  # POST /resource
  def create
    @sign_up = SignUp.new(sign_up_params)
    if @sign_up.save
      sign_in @sign_up.user
      redirect_to root_path, notice: "Account was created successully!"
    else
      render :new
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

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

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
  protected

  # Override method to use our own sanitizer for this object
  def devise_parameter_sanitizer
    super
    params = ActionController::Parameters.new(request.params)
      .permit(
        :utf8,
        :authenticity_token,
        :commit,
        sign_up: [
          :first_name,
          :last_name,
          :email,
          :password,
          :password_confirmation,
          :organization_name,
          :time_zone
        ]
      )
    SignUpParameterSanitizer.new(SignUp, :sign_up, params)
  end
end
