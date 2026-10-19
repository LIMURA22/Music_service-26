json.extract! collab_board, :id, :title, :description, :looking_for, :city, :genre, :user_id, :created_at, :updated_at
json.url collab_board_url(collab_board, format: :json)
