class Admin::PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!

  def index
    @pending_posts = Post.pending.order(created_at: :desc)
    @approved_posts = Post.approved.order(created_at: :desc)
    @rejected_posts = Post.rejected.order(created_at: :desc)
  end

  def approve
    @post = Post.find(params[:id])
    @post.update(status: "approved")
    redirect_to admin_posts_path, notice: "Пост «#{@post.title.truncate(40)}» одобрен и опубликован."
  end

  def reject
    @post = Post.find(params[:id])
    @post.update(status: "rejected")
    redirect_to admin_posts_path, notice: "Пост «#{@post.title.truncate(40)}» отклонён."
  end

  private

  def require_admin!
    unless current_user&.admin?
      redirect_to root_path, alert: "Доступ только для администратора."
    end
  end
end