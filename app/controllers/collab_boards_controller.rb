class CollabBoardsController < ApplicationController
  before_action :authenticate_user! 
  before_action :set_collab_board, only: %i[ show edit update destroy ]

  def index
    @collab_boards = CollabBoard.all.order(created_at: :desc)
    
    
    if params[:search].present?
      @collab_boards = @collab_boards.where("title ILIKE :search OR description ILIKE :search", search: "%#{params[:search]}%")
    end
    if params[:city].present?
      @collab_boards = @collab_boards.where(city: params[:city])
    end
  end

  def show
  end

  def new
    @collab_board = current_user.collab_boards.build
  end

  def create
    @collab_board = current_user.collab_boards.build(collab_board_params)
    if @collab_board.save
      redirect_to @collab_board, notice: "Объявление создано!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @collab_board.update(collab_board_params)
      redirect_to @collab_board, notice: "Объявление обновлено."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @collab_board.destroy
    redirect_to collab_boards_path, notice: "Объявление удалено."
  end

  private

  def set_collab_board
    @collab_board = CollabBoard.find(params[:id])
  end

  def collab_board_params
    params.require(:collab_board).permit(:title, :description, :looking_for, :city, :genre)
  end
end