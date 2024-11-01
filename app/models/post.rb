class Post < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :answers
  has_many_attached :photos
  has_many :votes
  has_many :answers, dependent: :destroy
end
