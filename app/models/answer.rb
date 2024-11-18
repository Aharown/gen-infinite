class Answer < ApplicationRecord
  acts_as_votable
  belongs_to :user
  belongs_to :post
  has_many :votes
end

def upvote
  @answer = find_post
  @answer.liked_by(current_user)
  redirect_to @post
end

def downvote
  @answer.unliked_by(current_user)
  redirect_to @post
end
