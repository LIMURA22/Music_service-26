class AddPostImageToPosts < ActiveRecord::Migration[8.1]
  def change
    add_column :posts, :post_image, :string
  end
end
