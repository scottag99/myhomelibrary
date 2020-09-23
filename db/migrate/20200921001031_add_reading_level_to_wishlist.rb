class AddReadingLevelToWishlist < ActiveRecord::Migration[5.2]
  def change
    add_reference :wishlists, :reading_level, foreign_key: true
  end
end
