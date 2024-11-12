class Post < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many_attached :photos
  has_many :votes
  has_many :answers, dependent: :destroy
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags
end
