class Admin::WishlistsController < Admin::BaseController
  include CommonWishlistActions

  def update
    @wishlist = current_campaign.wishlists.find(params[:id])
    @wishlist.update!(wishlist_params)
    respond_to do |format|
      format.html { redirect_to admin_organization_campaign_url(current_organization, current_campaign) }
      format.json { render json: @wishlist }
    end
  end

  def create
    @wishlist = current_campaign.wishlists.create!(wishlist_params)
    respond_to do |format|
      format.html { redirect_to admin_organization_campaign_url(current_organization, current_campaign) }
      format.json { render json: @wishlist }
    end
  end

  def destroy
    current_campaign.wishlists.delete(params[:id])
    respond_to do |format|
      format.html { redirect_to admin_organization_campaign_url(current_organization, current_campaign) }
      format.json { render json: current_campaign.wishlists.all}
    end
  end
private
    def current_organization
      Organization.find(params[:organization_id])
    end

    def current_campaign
      current_organization.campaigns.find(params[:campaign_id])
    end
end
