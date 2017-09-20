class AddIsDeliveredToWishlist < ActiveRecord::Migration[5.0]
  def change
    add_column :wishlists, :is_delivered, :boolean, default: false
  end
end
