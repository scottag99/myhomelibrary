class CreateWishlistEntries < ActiveRecord::Migration[5.0]
  def change
    create_table :wishlist_entries do |t|
      t.references :wishlist, foreign_key: true
      t.references :catalog_entry, foreign_key: true

      t.timestamps
    end
  end
end
