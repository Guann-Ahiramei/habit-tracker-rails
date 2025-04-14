class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create, :destroy]
  def new
  end

  def create
    # user = User.find_by(email: params[:email])
    # if user&.authenticate(params[:password])
    #   session[:user_id] = user.id
    #   redirect_to dashboard_path, notice: 'Sign in successfully'
    # else
    #   flash[:alert] = 'Incorrect e-mail or password'
    #   render :new
    # end

    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      puts "User logged in: #{user.id}"  # 这里打印一下 user_id
      redirect_to dashboard_path, notice: 'Sign in successfully'
    else
      flash[:alert] = 'Incorrect e-mail or password'
      puts "Login failed for email: #{params[:email]}"  # 这里打印一下尝试登录的 email
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: 'logged out'
  end
end
