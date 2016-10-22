class Partner::CampaignsController < Partner::BaseController
  include CommonCampaignActions

private
  #TODO:restrict to partner organizations if not admin
  def current_organization
    Organization.find(params[:organization_id])
  end

end
