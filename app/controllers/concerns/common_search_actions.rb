module CommonSearchActions
  extend ActiveSupport::Concern
  
  def find_wishlists
    term = params[:term]
    ids = (session[:wishlist_cart] || "").split(",").map(&:to_i)
    if term.to_s.size < 2
      if @organization.nil?
        where = "(deadline > ? and ready_for_donations = ?)"
        where_args = [Date.today, true]
      else
        where = "(deadline > ? and ready_for_donations = ? and organizations.id = ?)"
        where_args = [Date.today, true, @organization.id]
      end
      @wishlists = Wishlist.has_books.includes([{campaign: :organization}, {wishlist_entries: {catalog_entry: :book}}]).where("wishlists.id in (?)", ids)
      @wishlists = @wishlists + Wishlist.has_books.joins({campaign: :organization}).includes([{campaign: :organization}, {wishlist_entries: {catalog_entry: :book}}]).where(where, *where_args).order('random()').limit(20)
    else
      term = "%#{term.downcase}%"
      if @organization.nil?
        where = "wishlists.id in (?) or (deadline > ? and ready_for_donations = ? and (lower(reader_name) like ? or lower(teacher) like ? or lower(organizations.name) like ?))"
        where_args = [ids, Date.today, true, term, term, term]
      else
        where = "wishlists.id in (?) or (deadline > ? and ready_for_donations = ? and organizations.id = ? and (lower(reader_name) like ? or lower(teacher) like ?))"
        where_args = [ids, Date.today, true, @organization.id, term, term]
      end
      @wishlists = Wishlist.has_books.joins({campaign: :organization}).includes([{campaign: :organization}, {wishlist_entries: {catalog_entry: :book}}]).where(where, *where_args).order(:reader_name).all
    end
    wishlist_ids = @wishlists.collect{|w| w.id}
    @wishlist_prices = WishlistEntry.group("wishlist_id").where("wishlist_id in (?)", wishlist_ids).sum(:price)
    @donations = Donation.group("wishlist_id").where("wishlist_id in (?)", wishlist_ids).sum(:amount)
    @classroom_sponsored = Donation.where("wishlist_id in (?)", wishlist_ids).pluck(:wishlist_id)
  end
end
