class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post

  def create
    unless @post.likes.exists?(user: current_user)
      @post.likes.create(user: current_user)
    end
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @post }
    end
  end

  def destroy
    like = @post.likes.find_by(user: current_user)
    like&.destroy
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @post }
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end
end