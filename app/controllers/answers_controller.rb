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

    if @answer.save
      redirect_to post_path(@post)
    else
      redirect_to post_path(@post), alert: 'Failed to add comment.'
    end
  end


  def edit
  end

  def update
    @answer = Answer.find(params[:id])
  end

  def destroy
    @answer = Answer.find(params[:id])
    if @answer.destroy
      redirect_to post_path, notice: "Comment has been deleted 🗑️."
    else
      redirect_to post_path, alert: "Failed to delete the comment 🛑."
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:content)
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

end
