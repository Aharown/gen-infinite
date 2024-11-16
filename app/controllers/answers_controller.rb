class AnswersController < ApplicationController
  before_action :set_answer, only: [:edit, :update, :destroy]

  def index
    @answer = Answer.all
  end

  def new
    @answer = Answer.new
  end

  def create
    @post = Post.find(params[:post_id])
    @answer = @post.answers.build(answer_params)
    @answer.user = current_user
    @answer.parent_id = params[:answer][:parent_id] 

    if @answer.save
      redirect_to post_path(@post)
    else
      redirect_to post_path(@post), alert: 'Failed to add comment.'
    end
  end

  def edit
  end

  def update
    if @answer.update(answer_params)
      redirect_to post_path(@answer.post), notice: "Comment has been updated ✅."
    else
      redirect_to post_path(@answer.post), alert: 'Failed to update comment.'
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    if @answer.destroy
      redirect_to post_path, notice: "Comment has been deleted 🗑️."
    else
      redirect_to post_path, alert: "Failed to delete the comment 🛑."
    end
  end

  def upvote
    @answer.liked_by(current_user)
    redirect_to @answer.post
  end

  def downvote
    @post.unliked_by(current_user)
    redirect_to @answer.post
  end

  private

  def answer_params
    params.require(:answer).permit(:content, :parent_id)
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end
end
