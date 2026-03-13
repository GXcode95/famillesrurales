# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


user = User.find_or_create_by(email: 'user@mail.io')
user.password = 'password'
user.save!

event = Event.find_or_create_by(
  name: "Event 1",
  body: 'First event body',
  date: Time.now
)

category = Category.find_or_create_by!(name: 'Category 1')
activity = Activity.find_or_create_by!(
  name: 'Activity 1',
  category_id: category.id,
  manager_email: 'manager@mail.io',
  start_date: Time.now,
  start_time: Time.now,
  end_time: Time.now,
  manager_name: 'Manager',
  manager_phone: '0123456789',
  pricing: '120',
  teacher_name: 'Teacher',
  info: 'Activity informations ...',
)


Post.find_or_create_by!(
  title: 'Post 1',
  body: 'Post body ...'
)
