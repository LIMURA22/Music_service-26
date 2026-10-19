class AddSearchVisibilityToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :is_searchable, :boolean, default: true
    add_column :users, :telegram, :string
    add_column :users, :vk, :string
  end
end
