class VotesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_votable

  def create
    if current_user.voted_up_on?(@votable)
      @votable.unliked_by(current_user)
    else
      @votable.liked_by(current_user)
    end
    render json: vote_counts
  end

  def destroy
    @votable.unliked_by(current_user)
    render json: vote_counts
  end

  private

  def find_votable
    @votable = YourModel.find(params[:id]) # Replace with actual votable lookup logic
  end

  def vote_counts
    {
      upvotes: @votable.get_upvotes.size,
      downvotes: @votable.get_downvotes.size
    }
  end
end
