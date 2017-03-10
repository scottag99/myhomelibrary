class AddExternalIdToWishlist < ActiveRecord::Migration[5.0]
  def change
    add_column :wishlists, :external_id, :string
  end
end
