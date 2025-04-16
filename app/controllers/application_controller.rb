class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  protect_from_forgery with: :exception # CSRF 保护显式开启
  allow_browser versions: :modern
  helper_method :current_user

  def current_user
    # 从 session 中获取用户 ID，并查找用户
    # @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
    user = User.find_by(id: session[:user_id])
    puts "Session User ID: #{session[:user_id]}"
    puts "Current User: #{user.inspect}"
    @current_user ||= user
  end

  def authenticate_user!
    # unless current_user
    #   redirect_to login_path, alert: "please log in first"
    # end

    
    puts "Checking authentication: Current User - #{current_user.inspect}"
    unless current_user
      puts "User not authenticated, redirecting..."
      redirect_to login_path, alert: "Please log in first."
    end
  end
end
