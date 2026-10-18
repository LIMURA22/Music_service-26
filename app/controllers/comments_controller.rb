class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post

  def create
    authorize! :create, Comment
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
    authorize! :destroy, @comment 
    
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