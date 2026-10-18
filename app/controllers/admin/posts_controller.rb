class Admin::PostsController < ApplicationController
  before_action :authenticate_user!

  def index
    authorize! :manage, Post 
    @pending_posts = Post.pending.order(created_at: :desc)
    @approved_posts = Post.approved.order(created_at: :desc)
    @rejected_posts = Post.rejected.order(created_at: :desc)
  end

  def approve
    @post = Post.find(params[:id])
    authorize! :manage, @post
    @post.update(status: "approved")
    redirect_to admin_posts_path, notice: "Пост «#{@post.title.truncate(40)}» одобрен и опубликован."
  end

  def reject
    @post = Post.find(params[:id])
    authorize! :manage, @post
    @post.update(status: "rejected")
    redirect_to admin_posts_path, notice: "Пост «#{@post.title.truncate(40)}» отклонён."
  end
end