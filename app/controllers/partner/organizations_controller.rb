class Partner::OrganizationsController < Partner::BaseController
  include CommonOrganizationActions
  before_action :set_organization
end
