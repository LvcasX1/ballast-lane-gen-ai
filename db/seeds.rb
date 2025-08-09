# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
#
# Seed demo data for local testing
require "bcrypt"

user = User.find_or_create_by!(email: "demo@example.com") do |u|
  u.name = "Demo User"
  u.password = "password"
  u.password_confirmation = "password"
end

sample_tasks = [
  { title: "Buy groceries", description: "Milk, eggs, bread", status: :pending,     due_date: Date.today + 3 },
  { title: "Write report",  description: "Quarterly metrics",    status: :in_progress, due_date: Date.today + 7 },
  { title: "Pay bills",      description: "Utilities and rent",   status: :done,        due_date: Date.today - 1 }
]

sample_tasks.each do |attrs|
  user.tasks.find_or_create_by!(title: attrs[:title]) do |t|
    t.description = attrs[:description]
    t.status = attrs[:status]
    t.due_date = attrs[:due_date]
  end
end

puts "Seeded demo user demo@example.com with password 'password' and #{user.tasks.count} tasks"
