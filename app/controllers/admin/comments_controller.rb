class Admin::CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!

  def index
    @active_comments = Comment.active.order(created_at: :desc).includes(:post)
    @deleted_comments = Comment.deleted.order(deleted_at: :desc).includes(:post)
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.update(deleted_at: Time.current)
    redirect_to admin_comments_path, notice: "Комментарий перемещён в корзину."
  end

  def restore
    @comment = Comment.find(params[:id])
    @comment.update(deleted_at: nil)
    redirect_to admin_comments_path, notice: "Комментарий восстановлен."
  end
end