class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :post
  has_many :votes
end
