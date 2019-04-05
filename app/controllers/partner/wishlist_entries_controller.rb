class Partner::WishlistEntriesController < Partner::BaseController
  include CommonWishlistEntryActions
  before_action :find_organization

  def update
    @wishlist_entry = current_wishlist.wishlist_entries.find(params[:id])
    @wishlist_entry.update!(wishlist_entry_params)
    respond_to do |format|
      format.html { render "show" }
      format.json { render json: @wishlist_entry }
    end
  end

  def new
    @wishlist_entry = current_wishlist.wishlist_entries.new
    respond_to do |format|
      format.html
      format.json { render json: @wishlist_entry }
    end
  end

  def destroy
    current_wishlist.wishlist_entries.delete(params[:id])
    respond_to do |format|
      format.html { render "index" }
      format.json { render json: current_wishlist.wishlist_entries.all}
    end
  end
  private
    def current_organization
      @organization
    end

    def current_campaign
      current_organization.campaigns.find(params[:campaign_id])
    end

    def current_wishlist
      current_campaign.wishlists.find(params[:wishlist_id])
    end

    def wishlist_entry_params
      params.require(:wishlist_entry).permit(:catalog_entry_id)
    end
  end
