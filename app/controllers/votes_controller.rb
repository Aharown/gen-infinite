class VotesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_votable

  def create
    case params[:vote_type]
    when "upvote"
      toggle_upvote(@votable)
    when "downvote"
      toggle_downvote(@votable)
    else
      render json: { error: "Invalid vote type" }, status: :unprocessable_entity
      return
    end

    render json: {
      upvotes: @votable.get_upvotes.size,
      downvotes: @votable.get_downvotes.size
    }
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  private

  def find_votable
    @votable = Post.find(params[:id]) # Adjust as needed
  end

  def toggle_upvote(votable)
    if current_user.voted_up_on?(votable)
      votable.unliked_by(current_user)
    else
      votable.liked_by(current_user)
    end
  end

  def toggle_downvote(votable)
    if current_user.voted_down_on?(votable)
      votable.undisliked_by(current_user)
    else
      votable.downvoted_by(current_user)
    end
  end
end
