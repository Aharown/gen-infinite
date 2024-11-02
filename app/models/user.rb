class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one_attached :profile_photo
  has_many :posts, dependent: :destroy
  has_many :votes
  has_many :answers, dependent: :destroy
  has_many :user_categories, dependent: :destroy
  has_many :categories_of_interest, through: :user_categories, source: :category
  attribute :reputation, default: 0.0
end
