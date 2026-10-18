class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_likeable

  def create
    authorize! :create, Like
    @like = @likeable.likes.build(user: current_user)

    if @like.save
      redirect_back(fallback_location: root_path, notice: "Лайк поставлен!")
    else
      redirect_back(fallback_location: root_path, alert: "Не удалось поставить лайк.")
    end
  end

  def destroy
    @like = @likeable.likes.find_by(user: current_user)
    authorize! :destroy, @like
    
    if @like&.destroy
      redirect_back(fallback_location: root_path, notice: "Лайк убран.")
    end
  end

  private

  def set_likeable
    @likeable = if params[:post_id]
                  Post.find(params[:post_id])
                elsif params[:comment_id]
                  Comment.find(params[:comment_id])
                end
  end
end