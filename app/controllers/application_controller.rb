class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def all_posts_from_all_users
    @posts = Post.order("updated_at DESC")
  end

  def all_posts_from_current_user
    @posts = Post.group('posts.id').where([
      'created_at >= :date', 
      'user = :value',
      {:date => 1.week.ago.utc, :value => current_user.name}
    ]).order('count(id) desc')
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:name, :email, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :name, :email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:name, :email, :password, :password_confirmation, :current_password) }
  end

  def set_json(opt)
      @json = Hash.new
      opt.each_pair{|k, v| @json[k] = v}
      @json[:type] ="text/javascript"
      @json[:compiled] = Hash.new
      @json[:compiled][:by] = @current_user ? @current_user.name : "anonymous"
      @json[:compiled][:at] = Time.now
      @json.to_json
  end
end
