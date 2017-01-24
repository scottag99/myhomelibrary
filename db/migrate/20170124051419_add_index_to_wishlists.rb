class AddIndexToWishlists < ActiveRecord::Migration[5.0]
  def change
    add_index :wishlists, :reader_name
    add_index :wishlists, :teacher
  end
end
