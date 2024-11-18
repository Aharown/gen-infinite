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
    p @answer
    p @answer.user

  if @answer.save
    render json: {
    id: @answer.id,
    post_id: @post.id,
    content: @answer.content,
    username: @answer.user.username,
    profile_photo_url: @answer.user.profile_photo.url,
    is_current_user: @answer.user == current_user,
    success: true },
    status: :ok
  else
    render json: { success: false, errors: @answer.errors.full_messages }, status: :unprocessable_entity
  end
end

  def edit
  end

  def update
    if @answer.update(answer_params)
      render json: { content: @answer.content, id: @answer.id, success: true }, status: :ok
    else
      render json: { errors: @answer.errors.full_messages, success: false }, status: :unprocessable_entity
    end
  end

  def destroy
    @answer = Answer.find(params[:id])

    if @answer.destroy
      render json: { message: "Comment deleted successfully." }, status: :ok
    else
      render json: { error: "Failed to delete the comment." }, status: :unprocessable_entity
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
    params.require(:answer).permit(:content)
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end
end
