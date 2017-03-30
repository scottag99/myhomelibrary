class Partner::WishlistsController < Partner::BaseController
  include CommonWishlistActions
  before_action :set_organization

  def update
    @wishlist = current_campaign.wishlists.find(params[:id])
    @wishlist.update!(wishlist_params)
    respond_to do |format|
      format.html { redirect_to partner_organization_campaign_url(current_organization, current_campaign) }
      format.json { render json: @wishlist }
    end
  end

  def create
    @wishlist = current_campaign.wishlists.create!(wishlist_params)
    respond_to do |format|
      format.html { redirect_to partner_organization_campaign_url(current_organization, current_campaign) }
      format.json { render json: @wishlist }
    end
  end

private
    #TODO: restrict to partner orgs if not admin
    def current_organization
      @organization
    end

    def current_campaign
      current_organization.campaigns.find(params[:campaign_id])
    end

    def get_add_url(wishlist)
      partner_organization_campaign_wishlist_wishlist_entries_url(current_organization, current_campaign, wishlist)
    end

    def get_delete_url(wishlist)
      partner_organization_campaign_wishlist_wishlist_entry_url(current_organization, current_campaign, wishlist, ':id')
    end

    def get_done_url(wishlist)
      partner_organization_campaign_wishlist_url(current_organization, current_campaign, wishlist)
    end
end
