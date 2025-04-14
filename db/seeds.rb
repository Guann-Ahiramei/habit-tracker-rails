# 清空数据库（可选，根据需求启用）
User.destroy_all
Habit.destroy_all
Category.destroy_all
CategoriesHabit.destroy_all
Reminder.destroy_all
Follow.destroy_all
TimeBlock.destroy_all

# 创建用户
user1 = User.create!(email: "alice@example.com", password: "password123", role: "user")
user2 = User.create!(email: "bob@example.com", password: "password456", role: "user")

# 创建习惯
habit1 = Habit.create!(name: "Morning Run", description: "Run 5km every morning", user: user1)
habit2 = Habit.create!(name: "Read Books", description: "Read for 30 minutes daily", user: user2)

# 创建类别
category1 = Category.create!(name: "Health")
category2 = Category.create!(name: "Education")

# 关联习惯和类别
CategoriesHabit.create!(habit: habit1, category: category1)
CategoriesHabit.create!(habit: habit2, category: category2)

# 创建提醒
Reminder.create!(habit: habit1, reminder_time: Time.now + 6.hours)
Reminder.create!(habit: habit2, reminder_time: Time.now + 10.hours)

# 创建关注关系（user2 关注 user1）
Follow.create!(follower_id: user2.id, followed_id: user1.id)

# 创建时间块
TimeBlock.create!(habit: habit1, start_time: Time.now, end_time: Time.now + 1.hour, completed: true, reason: "Felt great!")
TimeBlock.create!(habit: habit2, start_time: Time.now + 2.hours, end_time: Time.now + 3.hours, completed: false, reason: "Got distracted.")

puts "Database seeding completed!"
