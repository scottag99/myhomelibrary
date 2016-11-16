class Partner::HomeController < Partner::BaseController
  before_action :set_organizations
  def index
  	@campaigns = Campaign.where(:organization => @organizations).all
    respond_to do |format|
      format.html
      format.json { render json: @campaigns }
    end
  end

end
