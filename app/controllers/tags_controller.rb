class TagsController < ApplicationController
  before_action :set_tag, only: [:show, :destroy]
  before_action :set_categories, only: [:new, :edit, :create, :update]

  def index
    @tag = Tag.new(category: @category)
  end

  def show
    @posts = @tags.posts
  end

  def new
    @tag = Tag.new
  end

  def create
    @tag = Tag.new(tag_params)
    @tag.category = @category

    if @tag.save
      redirect_to @tag, notice: 'Tag has been created. ✅'
    else
      render :new
    end
  end

  def destroy
    if @tag.destroy
      redirect_to tags_url, notice: 'Tag was successfully deleted. 🗑️'
    else
      redirect_to tags_url, alert: "Failed to delete the tag. 🛑"
    end
  end

  private

  def set_tag
    @tag = Tag.find(params[:id])
  end

  def set_categories
    @category = Category.find(params[:category_id])
  end

  def tag_params
    params.require(:tag).permit(:name, :category_id)
  end
end
