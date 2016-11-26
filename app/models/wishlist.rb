class Wishlist < ApplicationRecord
  belongs_to :campaign
  has_many :wishlist_entries, :dependent => :destroy
  has_many :donations
  has_many :catalog_entries, through: :wishlist_entries

  def donation_total
    donations.sum(:amount)
  end

  def wishlist_total
    catalog_entries.sum(:price)
  end

  def public_name
    parts = reader_name.split
    if parts.count >= 2
      "#{parts[0]} #{parts[1].slice(0)}."
    else
      reader_name
    end
  end
end
