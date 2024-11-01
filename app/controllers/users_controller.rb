class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:show]

  def show
    @user = User.find(params[:id])
  end
end

private

def set_user
  @user = User.select(:id, :username, :intro, :bio)
              .includes(:posts)
              .find(params[:id])
end
