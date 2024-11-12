class Tag < ApplicationRecord
  belongs_to :category
  has_many :post_tags
  has_many :posts, through: :taggings

  validates :name, presence: true, uniqueness: { scope: :category_id }
end
