class Partner::CampaignsController < Partner::BaseController
  include CommonCampaignActions
  before_action :set_organization
end
