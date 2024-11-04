class Category < ApplicationRecord
  has_many :posts
  has_many :user_categories, dependent: :destroy
  has_many :interested_users, through: :user_categories, source: :user
end
