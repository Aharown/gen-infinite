class VotesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_votable

  def upvote
    @post = Post.find(params[:id])
    @post.upvote_by current_user
    redirect_to @post
  end

  def downvote
    @post = Post.find(params[:id])
    @post.downvote_from current_user
    redirect_to @post
  end

  private

  def find_votable
    votable_type = params[:votable_type].capitalize
    votable_id = params[:votable_id]
    @votable = votable_type.constantize.find(votable_id)
  end
end
