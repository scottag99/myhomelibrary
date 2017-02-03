class Book < ApplicationRecord
  has_many :catalog_entries

  validates :isbn, :presence => true
end
