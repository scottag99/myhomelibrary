class Admin::CampaignsController < Admin::BaseController
  include CommonCampaignActions

  def update
    @campaign = current_organization.campaigns.find(params[:id])
    @campaign.update!(campaign_params)
    respond_to do |format|
      format.html { render "index" }
      format.json { render json: @campaign }
    end
  end

  def new
    @campaign = current_organization.campaigns.new
    respond_to do |format|
      format.html
      format.json { render json: @campaign }
    end
  end

  def create
    @campaign = current_organization.campaigns.create!(campaign_params)
    respond_to do |format|
      format.html { render "index" }
      format.json { render json: @campaign }
    end
  end

  def destroy
    current_organization.campaigns.delete(params[:id])
    respond_to do |format|
      format.html { render "index" }
      format.json { render json: current_organization.campaigns.all}
    end
  end
private
  def current_organization
    Organization.find(params[:organization_id])
  end

  def campaign_params
    params.require(:campaign).permit(:name, :deadline)
  end
end
