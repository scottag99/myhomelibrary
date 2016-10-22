class Admin::CampaignsController < Admin::BaseController
  include CommonCampaignActions
  before_action :set_organization

  def update
    @campaign = @organization.campaigns.find(params[:id])
    @campaign.update!(campaign_params)
    @campaigns = current_organization.campaigns
    flash[:success] = "Thank you! Your Campaign is update successfully."
    respond_to do |format|
      format.html { render "index" }
      format.json { render json: @campaign }
    end
  end

  def new
    @campaign = @organization.campaigns.new
    respond_to do |format|
      format.html
      format.json { render json: @campaign }
    end
  end

  def create
    @campaign = @organization.campaigns.create!(campaign_params)
    @campaigns = @organization.campaigns
    flash[:success] = "Thank you! Your Campaign is added successfully."
    respond_to do |format|
      format.html { render "index" }
      format.json { render json: @campaign }
    end
  end

  def destroy
    @organization.campaigns.delete(params[:id])
    @campaigns = @organization.campaigns
    flash[:success] = "Thank you! Your Campaign is delete successfully."

    respond_to do |format|
      format.html { render "index" }
      format.json { render json: @organization.campaigns.all}
    end
  end
private
  def set_organization
    @organization = Organization.find(params[:organization_id])
  end

  def campaign_params
    params.require(:campaign).permit(:name, :deadline)
  end
end
