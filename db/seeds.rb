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
Category.destroy_all
PostTag.destroy_all
Tag.destroy_all
Category.destroy_all

puts "Seeding categories and tags..."

categories = {
  "Technology" => ["AI", "Blockchain", "Cloud Computing", "Cybersecurity", "Programming", "Web Development"],
  "Entertainment" => ["Sports", "Gaming", "Movies", "Music", "Television"],
  "Lifestyle" => ["Sports", "Meals"],
  "Science" => ["Physics", "Biology", "Astronomy", "Chemestry"],
  "Education" => ["Online Learning", "Classroom Management", "EdTech", "Curriculum Development"],
  "Business" => ["Job Seeking", "Finance", "Project Management", "Human Ressources", "Marketing", "Economics", "Accounting"],
  "Politics" => ["Countries", "Sovereignty", "Democracy", "Dictatorship"],
  "Arts" => ["Painting", "Drawing", "Modern", "Pottery", "Knitting"],
  "Sports" => ["Football/Soccer", "American Football", "Tennis", "Basketball", "Volleyball", "Handball", "Natation"],
  "DIY & Crafts" => ["Pottery", "Knitting", "Wood Working"],
  "Parenting" => ["Baby Care", "Teenagers", "Adulthood", "Children Care", "School"],
  "Other" => ["Others"]
}

categories.each do |category_name, tags|
  category = Category.create!(name: category_name)
  tags.each do |tag_name|
    Tag.create!(name: tag_name, category: category)
  end
end

puts "Seeded categories and tags"

puts 'Seeding users...'

5.times do
  user = User.create!(
    username: Faker::Internet.username(specifier: 5..8),
    password: "password",
    email: Faker::Internet.email,
    intro: "A passionate #{Faker::Job.title.downcase} with a keen interest in #{Faker::Hobby.activity.downcase} and #{Faker::Educator.subject.downcase}.",
    bio: Faker::Quote.famous_last_words
  )

  user.categories_of_interest = Category.all.sample(rand(2..5))
end

puts 'Seeded users'

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
