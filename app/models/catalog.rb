class Catalog < ApplicationRecord
  before_destroy :confirm_no_wishlists #this has to be first
  has_many :catalog_entries, :dependent => :delete_all
  has_many :campaign_catalogs
  has_many :campaigns, through: :campaign_catalogs

protected

    def confirm_no_wishlists
      unless WishlistEntry.joins(:catalog_entry).where('catalog_id = ?', id).count() == 0
        errors.add(:base, "There are wishlists with books from this catalog. Deleting will make the system unstable.")
        throw :abort
      end
    end
end
