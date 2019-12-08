require 'roo'

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
    current_campaign.wishlists.destroy(params[:id])
    respond_to do |format|
      format.html { redirect_to admin_organization_campaign_url(current_organization, current_campaign) }
      format.json { render json: current_campaign.wishlists.all}
    end
  end

  def destroy_multiple
    @campaign = current_campaign
    @wishlists = current_campaign.wishlists.find(params[:wishlists_ids].split(',').map(&:to_i))
    @wishlists.each{|w| w.destroy()}
    respond_to do |format|
      format.js { render 'common/wishlists/destroy_multiple' }
      format.json { render json: @wishlists }
    end
  end

private
    def current_organization
      Organization.find(params[:organization_id])
    end

    def current_campaign
      current_organization.campaigns.find(params[:campaign_id])
    end

    def get_add_url(wishlist)
      admin_organization_campaign_wishlist_wishlist_entries_url(current_organization, current_campaign, wishlist)
    end

    def get_delete_url(wishlist)
      admin_organization_campaign_wishlist_wishlist_entry_url(current_organization, current_campaign, wishlist, ':id')
    end

    def get_done_url(wishlist)
      admin_organization_campaign_wishlist_url(current_organization, current_campaign, wishlist)
    end

    def get_campaign_url
      admin_organization_campaign_url(current_organization, current_campaign)
    end

    def get_take_survey_url(wishlist)
      take_survey_admin_organization_campaign_wishlist_url(current_organization, current_campaign, wishlist)
    end
end
