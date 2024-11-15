class CategoriesController < ApplicationController
  before_action :set_category, only: [:show]
  before_action :set_categories, only: [:index, :show]

  def tags
    @category = Category.find(params[:id])
    @tags = @category.tags

    respond_to do |format|
      format.json { render json: { tags_html: render_to_string(partial: "tags/form", locals: { tags: @tags }) } }
    end
  end


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
