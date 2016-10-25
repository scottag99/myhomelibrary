class Wishlist < ApplicationRecord
  belongs_to :campaign
  has_many :wishlist_entries, :dependent => :delete_all
  has_many :donations
  has_many :catalog_entries, through: :wishlist_entries

  def donation_total
    donations.sum(:amount)
  end

  def wishlist_total
    catalog_entries.sum(:price)
  end
end
