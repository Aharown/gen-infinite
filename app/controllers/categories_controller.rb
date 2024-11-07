class CategoriesController < ApplicationController
  before_action :set_category, only: [:show]
  before_action :set_categories, only: [:index, :show]

  def index
    @categories
  end

  def show
    @category = Category.find(params[:id])
    @posts = @category.posts
  end

  def new
  end

  def create
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def set_categories
    @categories = Category.all
  end
end
