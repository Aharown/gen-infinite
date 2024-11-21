class PostsController < ApplicationController
  before_action :set_post, only: %i[show edit update destroy]
  before_action :authorize_user!, only: %i[edit update destroy]
  before_action :find_post, only: %i[show upvote downvote]

  def index
    if params[:search] && params[:search][:query].present?
      @category = Category.find_by('lower(name) = ?', params[:search][:query].downcase)
      @posts = @category ? @category.posts.order(created_at: :desc) : Post.none
    elsif params[:category_id]
      @posts = Post.where(category_id: params[:category_id]).order(created_at: :desc)
    else
      @posts = Post.joins(:category)
                   .where(categories: { id: current_user.categories_of_interest })
                   .distinct
                   .order(created_at: :desc).limit(7)
    end
  end

  def show
    begin
      @post = Post.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = "Post not found"
      redirect_to posts_path
    end
    @answers = @post.answers.order(created_at: :desc)  # Order by newest first
    @new_answer = Answer.new
    @tags = @post.tags
  end

  def new
    @post = Post.new
    @tags = @post.category ? @post.category.tags : []
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
      redirect_to @post
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @post.destroy
      redirect_to posts_path
    else
      redirect_to posts_path, alert: "Failed to delete the post 🛑."
    end
  end

  def upvote
    if current_user.voted_up_on?(@post)
      @post.unliked_by(current_user) # Unlike if already upvoted
    else
      @post.liked_by(current_user) # Like otherwise
    end
    render json: vote_counts
  end

  def downvote
    if current_user.voted_down_on?(@post)
      @post.undisliked_by(current_user) # Remove dislike if already downvoted
    else
      @post.disliked_by(current_user) # Downvote otherwise
    end
    render json: vote_counts
  end

  private

  def post_params
    params.require(:post).permit(:title, :content, :category_id, photos: [], tag_ids: [])
  end

  def set_post
    @post = Post.find(params[:id])
    @tags = @post.category ? @post.category.tags : []
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

  def vote_counts
    {
      upvotes: @post.get_upvotes.size,
      downvotes: @post.get_downvotes.size
    }
  end
end
