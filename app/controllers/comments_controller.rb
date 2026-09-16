class CommentsController < ApplicationController
  before_action :authenticate_user!
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    if @comment.save
      redirect_to @post, notice: 'Комментарий добавлен.'
    else
      redirect_to @post, alert: 'Не удалось добавить комментарий.'
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])
    @comment.destroy
    redirect_to @post, notice: 'Комментарий удалён.'
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end