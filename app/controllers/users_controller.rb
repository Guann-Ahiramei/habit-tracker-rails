class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:show, :index, :create, :follow, :unfollow]
  before_action :authenticate_user!
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to @user, notice:'user sign up successfully'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @user = User.find(params[:id])
    @friends_stats = @user.followed_users.map do |friend|
      {
        friend: friend,
        daily_completion_rate: habit_completion_rate(friend, period: :daily),
        weekly_completion_rate: habit_completion_rate(friend, period: :weekly)
      }
    end
    @followed_users = @user.followed_users
    @followers = @user.followers
  end

  def index
    if current_user.nil?
      redirect_to new_user_session_path, alert: "Please log in to view this page."
      return
    end

    if params[:search].present?
      @searched_user = User.where("email LIKE ?", "%#{params[:search]}%").where.not(id: current_user.id).first
    end
    @followers = current_user.followers
    @followed_users = current_user.followed_users
    @weekly_habit_stats = calculate_weekly_habit_stats(@followed_users)
  end

  def follow
    @user = User.find(params[:id])
    current_user.followed_users << @user unless current_user.followed_users.include?(@user)
    redirect_to @user, notice: "You are now following #{@user.email}"
  end

  def unfollow
    @user = User.find(params[:id])
    current_user.followed_users.delete(@user)
    redirect_to @user, notice: "You have unfollowed #{@user.email}"
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :role)
  end

  def calculate_weekly_habit_stats(users)
    start_of_week = Time.current.beginning_of_week
    end_of_week = Time.current.end_of_week

    users.map do |user|
      completed_count = user.habits.joins(:time_blocks)
                              .where(time_blocks: { completed: true, start_time: start_of_week..end_of_week })
                              .count
      { user: user, completed_count: completed_count }
    end
  end
end
