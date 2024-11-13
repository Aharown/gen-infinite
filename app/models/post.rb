class Post < ApplicationRecord
  acts_as_votable
  belongs_to :user
  belongs_to :category
  has_many :answers
  has_many_attached :photos 
  has_many :votes, as: :votable, dependent: :destroy
  has_many :answers, dependent: :destroy
end

def upvote
  @post = find_post
  @post.liked_by(current_user)
  flash[:notice] = "Thanks for voting #{current_user.name}"
  redirect_to @post
end

def downvote
  @post.unliked_by(current_user)
  redirect_to @post
end
