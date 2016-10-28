class AddTeacherToWishlist < ActiveRecord::Migration[5.0]
  def change
    add_column :wishlists, :teacher, :string
  end
end
