module CommonWishlistActions
  extend ActiveSupport::Concern

  def index
    @wishlists = current_campaign.wishlists
    @campaign = current_campaign
    respond_to do |format|
      format.html
      format.json { render json: @wishlists }
    end
  end

  def show
    @wishlist = current_campaign.wishlists.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: @wishlist }
    end
  end
end
