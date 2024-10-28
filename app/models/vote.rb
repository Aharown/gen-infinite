class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :answer
  belongs_to :post
  attribute :vote_type, default: 0.0
end
