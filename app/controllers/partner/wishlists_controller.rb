class Partner::WishlistsController < Partner::BaseController
  include CommonWishlistActions

  def edit
    @wishlist = current_campaign.wishlists.find(params[:id])
    @add_url = partner_organization_campaign_wishlist_wishlist_entries_url(current_organization, current_campaign, @wishlist)
    @delete_url = partner_organization_campaign_wishlist_wishlist_entry_url(current_organization, current_campaign, @wishlist, ':id')
    @back_url = partner_organization_campaign_url(current_organization, current_campaign)

    respond_to do |format|
      format.html
      format.json { render json: @wishlist }
    end
  end

  def update
    @wishlist = current_campaign.wishlists.find(params[:id])
    @wishlist.update!(wishlist_params)
    respond_to do |format|
      format.html { render "show" }
      format.json { render json: @wishlist }
    end
  end

  def new
    @wishlist = current_campaign.wishlists.new
    respond_to do |format|
      format.html
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

  def destroy
    current_campaign.wishlists.delete(params[:id])
    respond_to do |format|
      format.html { redirect_to partner_organization_campaign_url(current_organization, current_campaign) }
      format.json { render json: current_campaign.wishlists.all}
    end
  end
private
    #TODO: restrict to partner orgs if not admin
    def current_organization
      Organization.find(params[:organization_id])
    end

    def current_campaign
      current_organization.campaigns.find(params[:campaign_id])
    end

    def wishlist_params
      params.require(:wishlist).permit(:reader_name, :reader_age, :reader_gender)
    end
end
