# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


require 'faker'

User.destroy_all
Post.destroy_all
Answer.destroy_all

puts 'Seeding users...'

5.times do
  User.create!(
    username: Faker::Internet.username(specifier: 5..8),
    password: "password",
    email: Faker::Internet.email,
    intro: "A passionate #{Faker::Job.title.downcase} with a keen interest in #{Faker::Hobby.activity.downcase} and #{Faker::Educator.subject.downcase}.",
    bio: Faker::Quote.famous_last_words
  )
end

puts 'Seeded users'

puts "Seeding categories..."

categories = [
  "Technology",
  "Entertainment",
  "Lifestyle",
  "Science",
  "Education",
  "Gaming",
  "Business",
  "Politics",
  "Arts",
  "Sports",
  "DIY & Crafts",
  "Parenting"
]

categories.each do |category_name|
  Category.create!(name: category_name)
end

puts "Seeded categories"

puts "Seeding posts..."

10.times do
  Post.create!(
    title: Faker::Book.title,
    content: Faker::Lorem.paragraph(sentence_count: 5),
    user: User.all.sample,
    category: Category.all.sample
  )
end

puts "Seeded posts"

puts 'Seeding answers...'

10.times do
  Answer.create!(
    content: Faker::Lorem.paragraph(sentence_count: 2),
    post: Post.all.sample,
    user: User.all.sample
  )
end

puts 'Answers seeded'
