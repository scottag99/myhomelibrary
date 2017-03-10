class AddGrlToWishlist < ActiveRecord::Migration[5.0]
  def change
    add_column :wishlists, :grl, :string
  end
end
