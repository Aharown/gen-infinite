class AnswersController < ApplicationController
  before_action :set_answer, only: [:edit, :update, :destroy]

  def index
    @answer = Answer.all
  end

  def new
    @answer = Answer.new
  end

  def create
    @answer = current_user.answer.build(answer_params)
    if @garment.save
      redirect_to post_path
    else
      render :new, status: :unprocessable_entity
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
