class AddWishlistEntryCounterToWishlist < ActiveRecord::Migration[5.0]
  def up
    add_column :wishlists, :wishlist_entry_count, :integer
    # if you need to populate for existing data
    Wishlist.reset_column_information
    Wishlist.find_each do |w|
      w.update_attribute :wishlist_entry_count, w.wishlist_entries.length
    end
  end

  def down
    remove_column :wishlists, :wishlist_entry_count
  end
end
