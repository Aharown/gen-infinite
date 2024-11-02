class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def index
    if params[:category_id]
      @posts = Post.where(category_id: params[:category_id])
    else
      @posts = Post.joins(:category)
                   .where(categories: { id: current_user.categories_of_interest })
                   .distinct
    end
  end

   def show
    @answers = @post.answers.includes(:user)
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save!
      redirect_to post_path(@post)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to @post, notice: "Post has been updated ✅."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @post.destroy
      redirect_to posts_path, notice: "Post has been deleted 🗑️."
    else
      redirect_to posts_path, alert: "Failed to delete the post 🛑."
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :content, :category_id, photos: [])
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end
end
