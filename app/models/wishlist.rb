class Wishlist < ApplicationRecord
  belongs_to :campaign
  has_many :wishlist_entries
  has_many :donations

  def donation_total
    donations.sum(:amount)
  end

end
