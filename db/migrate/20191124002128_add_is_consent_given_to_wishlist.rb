class AddIsConsentGivenToWishlist < ActiveRecord::Migration[5.2]
  def change
    add_column :wishlists, :is_consent_given, :boolean, default: true
    Wishlist.update_all(is_consent_given: true)
  end
end
