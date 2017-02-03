class CatalogEntry < ApplicationRecord
  belongs_to :catalog
  belongs_to :book
  has_many :wishlist_entries, :dependent => :destroy
  accepts_nested_attributes_for :book
end
