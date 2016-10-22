class Partner::HomeController < Partner::BaseController
  def index
  	@campaign = Campaign.all
    respond_to do |format|
      format.html 
      format.json { render json: @campaign }
    end
  end

end
