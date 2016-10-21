class CatalogEntry < ApplicationRecord
  belongs_to :catalog
  belongs_to :book
end
