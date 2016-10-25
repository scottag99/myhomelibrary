class Partner::HomeController < Partner::BaseController
  def index
  	@campaigns = Campaign.all
    respond_to do |format|
      format.html
      format.json { render json: @campaigns }
    end
  end

end
