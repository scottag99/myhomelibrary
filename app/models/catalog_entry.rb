class CatalogEntry < ApplicationRecord
  belongs_to :catalog
  belongs_to :book
  belongs_to :related_entry, :class_name => 'CatalogEntry'
  has_many :wishlist_entries, :dependent => :destroy
  accepts_nested_attributes_for :book

  def title
    book.title
  end

  def total_price
    total = price
    unless related_entry.nil?
      total += related_entry.price
    end
    total
  end
end
