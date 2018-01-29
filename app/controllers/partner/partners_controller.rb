class Partner::PartnersController < Partner::BaseController
  include CommonPartnerActions
  before_action :set_organization

private
  def set_organization
    @organization = Organization.find(params[:organization_id])
  end

  def partner_params
    params.require(:partner).permit(:name, :email, :active)
  end
end
