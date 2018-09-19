class Partner::BaseController < SecuredController
  layout 'admin'
  ALLOWED_ROLES = ['admin', 'partner', 'coordinator']

  rescue_from ActiveRecord::RecordNotFound do
    flash[:notice] = 'There is an issue with the records you are trying to access. Contact the campaign administrator to make sure you were added to the campaign and marked as active.'
    render :template => "errors/error_404", :status => 404
  end

  private
    def find_organization
      @organization = Organization.joins(:partners).where('partners.email = ? and partners.active = ?', session[:userinfo]['info']['email'], true).find(params[:organization_id])
    end

    def find_organizations
      @organizations = Organization.joins(:partners).where('partners.email = ? and partners.active = ?', session[:userinfo]['info']['email'], true).all
    end
end
