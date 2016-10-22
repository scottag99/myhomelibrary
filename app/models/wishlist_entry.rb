class WishlistEntry < ApplicationRecord
  belongs_to :wishlist
  belongs_to :catalog_entry
end
