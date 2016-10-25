class Admin::HomeController < Admin::BaseController
  def index
    @data = {:wishlists => Wishlist.count, :donations => Donation.sum(:amount)}
  end
end
