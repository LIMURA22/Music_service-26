class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authorize_owner_or_admin!, only: [:edit, :update, :destroy]

  def index
    @posts = Post.approved.order(created_at: :desc)
  end

  def my_posts
    @posts = current_user.posts.order(created_at: :desc)
  end

  def show
    @comment = Comment.new
    allowed = @post.approved? ||
              (user_signed_in? && (current_user.admin? || @post.user_id == current_user.id))
    unless allowed
      redirect_to posts_path, alert: "Этот пост ещё не прошёл модерацию."
    end
  end

  def new
    @post = Post.new
  end


  def create
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
  end

  def update
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
    @post.destroy
    redirect_to posts_path, notice: "Пост удалён."
  end

  private

  def authorize_owner_or_admin!
    unless current_user&.admin? || @post.user_id == current_user&.id
      redirect_to posts_path, alert: "Нет доступа."
    end
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def require_admin!
    unless current_user&.admin?
      redirect_to root_path, alert: "Доступ только для администратора."
    end
  end

  def post_params
    params.expect(post: [ :title, :description, :post_image ])
  end
end