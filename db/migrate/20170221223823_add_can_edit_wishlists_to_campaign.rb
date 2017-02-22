class AddCanEditWishlistsToCampaign < ActiveRecord::Migration[5.0]
  def change
    add_column :campaigns, :can_edit_wishlists, :boolean, default: true
  end
end
