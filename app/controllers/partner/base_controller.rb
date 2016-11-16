class Partner::BaseController < SecuredController
  layout 'admin'
  ALLOWED_ROLES = ['admin', 'partner']

  private
    def set_organization
      @organization = Organization.joins(:partners).where('partners.email = ? and partners.active = ?', session[:userinfo]['info']['email'], true).find(params[:organization_id])
    end

    def set_organizations
      @organizations = Organization.joins(:partners).where('partners.email = ? and partners.active = ?', session[:userinfo]['info']['email'], true).all
    end
end
