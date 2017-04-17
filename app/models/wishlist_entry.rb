class WishlistEntry < ApplicationRecord
  belongs_to :wishlist, counter_cache: true
  belongs_to :catalog_entry

  validate :validate_wishlist_entries

  def validate_wishlist_entries
    unless wishlist.campaign.book_limit.nil? || wishlist.campaign.book_limit == 0
      errors.add(:wishlist, "Book Limit Reached") if wishlist.wishlist_entry_count > wishlist.campaign.book_limit
    end
  end


end
