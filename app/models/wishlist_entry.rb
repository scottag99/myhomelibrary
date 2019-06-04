class WishlistEntry < ApplicationRecord
  belongs_to :wishlist, counter_cache: :wishlist_entry_count
  belongs_to :catalog_entry

  validate :validate_wishlist_entries
  validates :catalog_entry_id, uniqueness: { scope: :wishlist_id }

  def validate_wishlist_entries
    unless wishlist.campaign.book_limit.nil? || wishlist.campaign.book_limit == 0
      errors.add(:wishlist, "Book Limit Reached") if wishlist.wishlist_entries.size > wishlist.campaign.book_limit
    end
  end


end
