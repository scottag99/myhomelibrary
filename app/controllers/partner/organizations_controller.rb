class Partner::OrganizationsController < Partner::BaseController
  include CommonOrganizationActions
  before_action :find_organization, except: [:index, :update]

  def update
    @organization = Organization.find(params[:id])
    @organization.update!(org_params)
    respond_to do |format|
      format.html { redirect_to partner_organizations_url }
      format.json { render json: @organization }
    end
  end

private
  def find_organization
    @organization = Organization.joins(:partners).where('partners.email = ? and partners.active = ?', session[:userinfo]['info']['email'], true).find(params[:id])
  end

  def org_params
    params.require(:organization).permit(:name, :contact_name, :contact_email)
  end
end
