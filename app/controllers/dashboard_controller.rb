class DashboardController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:index]
  before_action :authenticate_user!
  
  def index
    puts "Current User: #{current_user.inspect}"
    start_of_week = Time.current.beginning_of_week
    end_of_week = Time.current.end_of_week

    # 本周完成的 time_blocks
    @completed_time_blocks = TimeBlock.where(completed: true, start_time: start_of_week..end_of_week)
    @completed_count = @completed_time_blocks.count
    @completed_habits = Habit.joins(:time_blocks)
                             .where(time_blocks: { id: @completed_time_blocks.pluck(:id) })
                             .distinct
                             .select('habits.*, COUNT(time_blocks.id) AS completed_times')
                             .group('habits.id')

    # 本周未完成的 time_blocks
    @incomplete_time_blocks = TimeBlock.where(completed: false, start_time: start_of_week..end_of_week)
    @incomplete_count = @incomplete_time_blocks.count
    @incomplete_habits = Habit.joins(:time_blocks)
                              .where(time_blocks: { id: @incomplete_time_blocks.pluck(:id) })
                              .distinct
                              .select('habits.*, COUNT(time_blocks.id) AS incomplete_times')
                              .group('habits.id')
  end
end
