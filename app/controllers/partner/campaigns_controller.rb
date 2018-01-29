class Partner::CampaignsController < Partner::BaseController
  include CommonCampaignActions
  before_action :find_organization
end
