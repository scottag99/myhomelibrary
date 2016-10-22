class Admin::CampaignsController < Admin::BaseController
  include CommonCampaignActions

  def update
    @campaign = current_organization.campaigns.find(params[:id])
    @campaign.update!(campaign_params)
    @campaigns = current_organization.campaigns
    flash[:success] = "Thank you! Your Campaign is update successfully."
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
    @campaigns = current_organization.campaigns
    flash[:success] = "Thank you! Your Campaign is added successfully."
    respond_to do |format|
      format.html { render "index" }
      format.json { render json: @campaign }
    end
  end

  def destroy
    current_organization.campaigns.delete(params[:id])
    @campaigns = current_organization.campaigns
    flash[:success] = "Thank you! Your Campaign is delete successfully."
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
