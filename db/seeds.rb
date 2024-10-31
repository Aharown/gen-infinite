# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'populator'
require 'faker'
User.destroy_all
Post.destroy_all
Answer.destroy_all

User.populate(5) do |user|
  user.name = Faker::Name.name
  user.email = Faker::Internet.email
  user.intro = "A passionate #{Faker::Job.title.downcase} with a keen interest in #{Faker::Hobby.activity.downcase} and #{Faker::Educator.subject.downcase}."
  user.bio = Faker::Quote.famous_last_words
end
Post.populate(10) do |post|
  post.title = Faker::Book.title
  post.content = Faker::Lorem.paragraph(sentence_count: 5)
  post.user_id = User.ids.sample
end
Answer.populate(10) do |answer|
  answer.content = Faker::Lorem.paragraph(sentence_count: 2)
  answer.post_id = Post.ids.sample
end
