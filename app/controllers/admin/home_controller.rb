class Admin::HomeController < Admin::BaseController
  def index
    @data = {:wishlists => Wishlist.count, :donations => Donation.sum(:amount), :sponsored_wishlists => Wishlist.includes(:donations).where.not(donations: {id: nil}).count()}
  end
end
