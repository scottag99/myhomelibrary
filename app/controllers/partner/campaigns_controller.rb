class Partner::CampaignsController < Partner::BaseController
  include CommonCampaignActions
  before_action :set_organization

private
  def set_organization
    @organization = Organization.find(params[:organization_id])
  end
end
