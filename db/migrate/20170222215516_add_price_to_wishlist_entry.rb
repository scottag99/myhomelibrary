class AddPriceToWishlistEntry < ActiveRecord::Migration[5.0]
  def change
    add_column :wishlist_entries, :price, :decimal
    WishlistEntry.includes(:catalog_entry).all.each{|w|
      w.price = w.catalog_entry.price
      w.save
    }
  end
end
