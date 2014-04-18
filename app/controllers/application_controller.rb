class ApplicationController < ActionController::Base
  
  SEARCHING_SESSION_MSG = "Searching for a session to "
  
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller?  

  def verify_session
    logger.info{"\t--> #{SEARCHING_SESSION_MSG} authenticate..."}
    if session[:session_id]
      logger.info{" ==>User #{@user.username} authenticated"}
      @user = User.find_by_id_digest session[:session_id]
      true
    else
      logger.info{" ==>Session not found"}
      false
    end
  end

  #This method for prevent user to access Signup & Login Page without logout
  def skip_set_user
    if session[:session_id]
      false
    else
      true
    end
  end

  def list_all_posts
    @posts = Post.all || []
  end
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :password, :password_confirmation, :current_password) }
  end

end
