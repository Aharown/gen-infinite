class PostTag < ApplicationRecord
  belongs_to :post
  belongs_to :tag
  acts_as_votable
end
