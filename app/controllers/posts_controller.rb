class PostsController < ApplicationController
  before_action :set_post, only: %i[show edit update destroy]
  before_action :authorize_user!, only: %i[edit update destroy]
  before_action :find_post, only: %i[show upvote downvote]

  def index
    if params[:category_id]
      @posts = Post.where(category_id: params[:category_id]).order(created_at: :desc)
    else
      @posts = Post.joins(:category)
                   .where(categories: { id: current_user.categories_of_interest })
                   .distinct
                   .order(created_at: :desc)
    end
  end

  def show
    begin
      @post = Post.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = "Post not found"
      redirect_to posts_path
    end
    @answers = @post.answers.order(created_at: :asc)
    @new_answer = Answer.new
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save!
      if params[:post][:media].present?
        params[:post][:media].each do |media|
          @post.photos.attach(media)
        end
      end
      redirect_to post_path(@post)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if params[:post][:media].present?
      params[:post][:media].each do |media|
        @post.photos.attach(media)
      end
    end

    if params[:remove_media].present?
      params[:remove_media].each do |photo_id|
        @post.photos.find(photo_id).purge
      end
    end

    if @post.update(post_params.except(:photos))
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

  def upvote
    @post = Post.find(params[:id])
    @post.liked_by(current_user)
    respond_to do |format|
      format.html { redirect_to @post }
      format.js
    end
  end

  def downvote
    @post = Post.find(params[:id])
    @post.unliked_by(current_user)
    respond_to do |format|
      format.html { redirect_to @post }
      format.js
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :content, :category_id, photos: [])
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def authorize_user!
    unless @post.user == current_user
      redirect_to posts_path, alert: "You are not authorized to perform this action."
    end
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def find_post
    @post = Post.find(params[:id])
  end
end
