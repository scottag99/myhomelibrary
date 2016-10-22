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
end
