class Admin::HomeController < Admin::BaseController
  def index
    redirect_to admin_organizations_path
    @data = {:wishlists => Wishlist.count, :donations => Donation.sum(:amount), :sponsored_wishlists => Wishlist.includes(:donations).where.not(donations: {id: nil}).count()}
  end
end
