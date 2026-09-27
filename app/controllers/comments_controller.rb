class CommentsController < ApplicationController
  before_action :set_post

  def create
    unless user_signed_in?
      store_location_for(:user, post_path(@post))
      redirect_to new_user_session_path, alert: "Войдите, чтобы оставить комментарий."
      return
    end
  
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user
  
    if @comment.save
      redirect_to @post, notice: "Комментарий добавлен."
    else
      redirect_to @post, alert: "Не удалось добавить комментарий."
    end
  end

  def destroy
    @comment = @post.comments.find(params[:id])
    unless current_user&.admin? || @comment.user_id == current_user&.id
      redirect_to @post, alert: "Нет доступа."
      return
    end
    @comment.update(deleted_at: Time.current)
    redirect_to @post, notice: "Комментарий удалён."
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end