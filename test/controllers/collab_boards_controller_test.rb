require "test_helper"

class CollabBoardsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @collab_board = collab_boards(:one)
  end

  test "should get index" do
    get collab_boards_url
    assert_response :success
  end

  test "should get new" do
    get new_collab_board_url
    assert_response :success
  end

  test "should create collab_board" do
    assert_difference("CollabBoard.count") do
      post collab_boards_url, params: { collab_board: { city: @collab_board.city, description: @collab_board.description, genre: @collab_board.genre, looking_for: @collab_board.looking_for, title: @collab_board.title, user_id: @collab_board.user_id } }
    end

    assert_redirected_to collab_board_url(CollabBoard.last)
  end

  test "should show collab_board" do
    get collab_board_url(@collab_board)
    assert_response :success
  end

  test "should get edit" do
    get edit_collab_board_url(@collab_board)
    assert_response :success
  end

  test "should update collab_board" do
    patch collab_board_url(@collab_board), params: { collab_board: { city: @collab_board.city, description: @collab_board.description, genre: @collab_board.genre, looking_for: @collab_board.looking_for, title: @collab_board.title, user_id: @collab_board.user_id } }
    assert_redirected_to collab_board_url(@collab_board)
  end

  test "should destroy collab_board" do
    assert_difference("CollabBoard.count", -1) do
      delete collab_board_url(@collab_board)
    end

    assert_redirected_to collab_boards_url
  end
end
