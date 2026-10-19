class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def index
    authorize! :read, Post
    @posts = Post.approved.order(created_at: :desc)
  end

  def my_posts
    authorize! :read, Post
    @posts = current_user.posts.order(created_at: :desc)
  end

  def show
    authorize! :read, @post
    @comment = Comment.new
  end

  def new
    authorize! :create, Post
    @post = Post.new
  end

  def create
    authorize! :create, Post
    @post = current_user.posts.build(post_params)

    if current_user.admin?
      @post.status = "approved"
      notice = "Пост опубликован."
    else
      @post.status = "pending"
      notice = "Спасибо! Пост отправлен на модерацию."
    end

    if @post.save
      redirect_to @post, notice: notice
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize! :update, @post
  end

  def update
    authorize! :update, @post
    if @post.update(post_params)
      unless current_user.admin?
        @post.update(status: "pending")
      end
      notice = current_user.admin? ? "Пост обновлён." : "Изменения отправлены на модерацию."
      redirect_to @post, notice: notice
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize! :destroy, @post
    @post.destroy
    redirect_to posts_path, notice: "Пост удалён."
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.expect(post: [ :title, :description, :post_image, tag_ids: [] ])
  end
end