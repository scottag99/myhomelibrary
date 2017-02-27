class AddGradeToWishlist < ActiveRecord::Migration[5.0]
  def change
    add_column :wishlists, :grade, :string
  end
end
