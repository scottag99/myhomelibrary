class Partner::HomeController < Partner::BaseController
  before_action :find_organizations
  def index
    if get_role == 'coordinator'
      redirect_to partner_organizations_url
    else
    	@campaigns = Campaign.where(:organization => @organizations).all
      respond_to do |format|
        format.html
        format.json { render json: @campaigns }
      end
    end
  end

end
