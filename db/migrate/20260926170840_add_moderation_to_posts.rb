class AddModerationToPosts < ActiveRecord::Migration[8.1]
  def change
    add_column :posts, :status, :string, default: "pending"
    add_reference :posts, :user, null: true, foreign_key: true
  end
end