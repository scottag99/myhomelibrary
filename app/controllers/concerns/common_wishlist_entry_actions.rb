module CommonWishlistEntryActions
  extend ActiveSupport::Concern

  def index
    @wishlist_entries = current_wishlist.wishlist_entries
    respond_to do |format|
      format.html
      format.json { render json: @wishlist_entries }
    end
  end

  def show
    @wishlist_entry = current_wishlist.wishlist_entries.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: @wishlist_entry }
    end
  end

  def create
    @wishlist_entry = current_wishlist.wishlist_entries.create(wishlist_entry_params)
    @wishlist_entry.price = @wishlist_entry.catalog_entry.total_price
    @wishlist_entry.save!
    respond_to do |format|
      format.html { render "show" }
      format.json { render json: @wishlist_entry }
    end
  end

end
