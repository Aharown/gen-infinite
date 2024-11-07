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
require 'open-uri'

User.destroy_all
Post.destroy_all
Answer.destroy_all
Category.destroy_all

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

user_categories = Category.where(name: ["Technology", "Gaming", "Science", "Parenting", "Education", "Lifestyle", "Arts", "Politics", "Business"])

def attach_profile_photo(user, is_blueman = false)
  if is_blueman
    user.profile_photo.attach(io: File.open(Rails.root.join('app', 'assets', 'images', 'blueman PP.png')), filename: 'blueman PP.png', content_type: 'image/png')
  else
    photo_url = Faker::LoremFlickr.image(size: "150x150", search_terms: ['person'])
    downloaded_image = URI.open(photo_url)
    user.profile_photo.attach(io: downloaded_image, filename: "profile_photo_#{user.id}.jpg", content_type: 'image/jpeg')
  end
end

puts 'Seeding users...'

10.times do
  user = User.create!(
    username: Faker::Internet.username(specifier: 5..8),
    password: "password",
    email: Faker::Internet.email,
    intro: "A passionate #{Faker::Job.title.downcase} with a keen interest in #{Faker::Hobby.activity.downcase} and #{Faker::Educator.subject.downcase}.",
    bio: Faker::Quote.famous_last_words
  )
  attach_profile_photo(user)

  user.categories_of_interest = Category.all.sample(rand(2..7))
end

puts 'Seeded users with specific categories of interest'



puts "Seeding specific user with profile photo..."

blueman_user = User.create!(
  username: "blueman",
  password: "password",
  email: "cheminko@hotmail.com",
  intro: "Techy | Married 30 years | 3 daughters | Movie buff | Gen Xer",
  bio: "I love to explore the latest trends in technology and gaming. I’ve been described by loved ones as insightful and a deep thinker and love to grapple with complexed problems! "
)

attach_profile_photo(blueman_user, true)
blueman_user.categories_of_interest = user_categories
puts "Assigned categories and profile photo to blueman_user"

puts "Seeding posts for blueman_user..."

user_categories.each_with_index do |category, i|
  Post.create!(
    title: "Post #{i + 1} by Blueman",
    content: "This is the content of post #{i + 1} by blueman.",
    user: blueman_user,
    category: category
  )
end
puts "Seeded posts for blueman_user"

puts "Seeding answers for blueman_user's posts from random users only..."

def generate_relevant_answer(post)
  case post.category.name
  when "Technology"
    "I agree with your take on #{Faker::Hacker.abbreviation}. The latest trends in technology like #{Faker::Hacker.say_something_smart} are really changing the way we interact with the world."
  when "Lifestyle"
    "Great insights! I think #{Faker::Marketing.buzzwords} is crucial to a balanced lifestyle. Have you tried any new practices to improve your daily routine?"
  when "Gaming"
    "The game you mentioned sounds amazing! I’m excited to try out #{Faker::Game.title}. I’ve heard that its #{Faker::Game.genre} elements really set it apart."
  when "Science"
    "#{Faker::Science.element} is a fascinating topic. Have you seen the latest research by #{Faker::Science.scientist} on its applications in the world of science?"
  when "Education"
    "I totally agree with your take on #{Faker::Educator.subject}. It's a key part of shaping future minds. Have you considered how this could be incorporated into #{Faker::Educator.university} curriculum?"
  when "Parenting"
    "Totally agree with your approach to parenting. It’s so important to encourage growth and resilience in children. What are your thoughts on discipline techniques?"
  when "Arts"
    "I love how you highlighted #{Faker::Music.genre} as an art form. The creativity behind it can be so powerful in shaping culture. Have you seen any exhibitions on this lately?"
  when "Politics"
    "Great points on current events in #{Faker::Nation.nationality}. The political landscape is shifting rapidly, and it’s crucial to stay informed."
  else
    "I really enjoyed reading your post. It’s inspiring to see so many perspectives on #{post.category.name}. Looking forward to more!"
  end
end

Post.where(user: blueman_user).each do |post|
  3.times do
    random_user = User.where.not(id: blueman_user.id).sample
    Answer.create!(
      content: generate_relevant_answer(post),
      post: post,
      user: random_user
    )
  end
end

puts "Seeded relevant answers for blueman_user's posts"

puts "Seeding posts with meaningful content in English..."

def generate_content_for_category(category)
  case category.name
  when "Technology"
    title = "The Future of Technology: Innovations You Should Know"
    content = <<-TEXT
      Technology is advancing at an unprecedented rate. One of the most exciting innovations on the horizon is the development of quantum computing, which promises to revolutionize fields ranging from cryptography to artificial intelligence. The potential for technology to improve lives is limitless, but with new advancements come new challenges, such as privacy concerns and ethical considerations. As we look toward the future, we must ask ourselves: How do we balance innovation with responsibility?
    TEXT
  when "Lifestyle"
    title = "Tips for a Balanced Life"
    content = <<-TEXT
      Living a balanced life isn't just about finding time for work and leisure; it's about ensuring your physical, mental, and emotional needs are met. Studies have shown that mindfulness practices like meditation can significantly reduce stress and improve overall well-being. Additionally, setting boundaries in both personal and professional life is crucial to maintaining mental health. Incorporating healthy habits, like regular exercise and proper nutrition, is key to maintaining energy levels and mental clarity. Remember, balance doesn't mean perfection—it means making intentional choices for your well-being.
    TEXT
  when "Gaming"
    title = "Exploring the World of Gaming: What's Next?"
    content = <<-TEXT
      The gaming industry is experiencing a golden age, with new technologies like virtual reality (VR) and augmented reality (AR) making the gaming experience more immersive than ever before. In addition to advancements in hardware, game developers are also pushing the boundaries of storytelling. Titles like "The Last of Us" and "Red Dead Redemption 2" have raised the bar for narrative depth in video games, blending cinematic storytelling with player choice. As we look to the future, we can expect to see more cross-platform games, live service models, and AI-driven gameplay that adapts to individual players' styles. Gaming is no longer just a hobby—it's a global phenomenon.
    TEXT
  when "Science"
    title = "The Wonders of Modern Science"
    content = <<-TEXT
      Science has led to some of the most groundbreaking discoveries in recent years, from CRISPR gene editing technology to the exploration of distant planets. In fields like biotechnology, scientists are on the verge of curing diseases that were once thought incurable, such as certain forms of cancer. In astronomy, advancements in telescope technology have revealed more about the universe than ever before, helping us understand our place in the cosmos. As we continue to unlock the mysteries of the natural world, we must remain aware of the ethical dilemmas these advancements present. How do we ensure that scientific progress serves humanity's best interests?
    TEXT
  when "Education"
    title = "Innovations in Education: Shaping the Future"
    content = <<-TEXT
      Education is evolving rapidly, especially in the digital age. Online learning platforms like Coursera and Khan Academy have democratized education, allowing people around the world to access quality content. However, with the rise of technology in education, we must also address issues like the digital divide, where students from underprivileged backgrounds may not have access to the necessary tools. The future of education will likely see more personalized learning experiences, with AI-driven tutoring systems and adaptive learning tools that cater to individual needs. The key question remains: How do we create an education system that is equitable, inclusive, and accessible to all?
    TEXT
  when "Parenting"
    title = "Parenting in the 21st Century: Navigating Challenges"
    content = <<-TEXT
      Parenting today presents unique challenges. With the rise of technology, children are exposed to screens at an earlier age than ever before. While technology can offer educational benefits, there are concerns about the impact of excessive screen time on mental and emotional development. Parenting in the 21st century also requires a balance between traditional values and modern ideas about discipline and responsibility. Strategies like positive reinforcement, mindfulness, and fostering emotional intelligence are becoming more widely accepted in parenting circles. As parents, it's important to foster open communication with children while also teaching them important life skills such as empathy, resilience, and problem-solving.
    TEXT
  when "Arts"
    title = "The Impact of Arts on Society"
    content = <<-TEXT
      The arts have always played a vital role in human society. Whether through visual arts, music, theater, or literature, the creative expression of individuals has been a mirror to society, reflecting its values, struggles, and hopes. The arts not only provide entertainment but also serve as a tool for social change. Historically, movements like the Harlem Renaissance or the countercultural movements of the 1960s used art to challenge the status quo and promote social justice. Today, the arts continue to push boundaries and offer new ways to address issues like mental health, inequality, and climate change. As we continue to face global challenges, the arts will remain a powerful force in shaping our collective future.
    TEXT
  when "Politics"
    title = "The Evolving Political Landscape"
    content = <<-TEXT
      The political landscape is constantly changing, with new issues emerging and old ones being redefined. In recent years, we’ve seen the rise of populist movements, both on the left and the right, challenging traditional political structures. Issues like climate change, healthcare, and income inequality are at the forefront of political debates, and the role of technology in politics has never been more pronounced. Social media platforms have become key battlegrounds for shaping public opinion, while misinformation and polarization present significant challenges for democracies. As we look to the future, the question remains: How will political systems adapt to these changing dynamics, and how can we ensure that all voices are heard in the democratic process?
    TEXT
  else
    title = "Exploring New Topics"
    content = "Explore interesting topics across various fields."
  end

  return title, content
end

User.all.each do |user|
  3.times do
    category = user.categories_of_interest.sample
    title, content = generate_content_for_category(category)
    Post.create!(
      title: title,
      content: content,
      user: user,
      category: category
    )
  end
end

puts "Seeded posts"

puts "Seeding answers for all users' posts..."

# Loop through all posts
Post.all.each do |post|
  # Generate 5 answers per post
  5.times do
    random_user = User.where.not(id: post.user.id).sample # Ensure the answer is from a different user
    Answer.create!(
      content: generate_relevant_answer(post),
      post: post,
      user: random_user
    )
  end
end

puts 'Answers seeded'

puts 'Seeding complete'
