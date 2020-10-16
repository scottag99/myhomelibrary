class Partner::CampaignsController < Partner::BaseController
  include CommonCampaignActions
  include PackResolver
  helper_method PackResolver.instance_methods
  before_action :find_organization
end
