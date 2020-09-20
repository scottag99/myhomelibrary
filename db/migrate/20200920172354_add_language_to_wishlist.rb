class AddLanguageToWishlist < ActiveRecord::Migration[5.2]
  def change
    add_reference :wishlists, :language, foreign_key: true
  end
end
