class CatalogEntry < ApplicationRecord
  belongs_to :catalog
  belongs_to :book
  has_many :wishlist_entries
end
