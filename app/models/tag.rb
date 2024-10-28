class Tag < ApplicationRecord
  belongs_to :category
  has_many :post_tags
end
