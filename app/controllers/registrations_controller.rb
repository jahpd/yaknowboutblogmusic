class RegistrationsController < Devise::RegistrationsController
  before_filter :update_sanitized_params, if: :devise_controller?

  def update_sanitized_params
    devise_parameter_sanitizer.for(:sign_up) {|u| u.permit(:name, :email, :password, :password_confirmation)}
    devise_parameter_sanitizer.for(:account_update) {|u| u.permit(:name, :email, :password, :password_confirmation, :current_password)}
  end

  # https://stackoverflow.com/questions/4140378/how-can-i-send-a-welcome-email-to-newly-registered-users-in-rails-using-devise
  def create
    super
    UserMailer.welcome(@user).deliver unless @user.invalid?
  end

end
