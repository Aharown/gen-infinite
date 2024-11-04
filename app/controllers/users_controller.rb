class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:show]

  def show
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to @user, notice: 'Account updated.'
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, category_ids: [])
  end

end

private

def set_user
  @user = User.select(:id, :username, :intro, :bio)
              .includes(:posts)
              .find(params[:id])
end
