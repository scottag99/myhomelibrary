class Partner::OrganizationsController < Partner::BaseController
  include CommonOrganizationActions

private
  #TODO: in this class, these methods should restrict to the user if not admin
  def find_organizations
    Organization.all
  end

  def find_organization
    Organization.find(params[:id])
  end

end
