module CommonCampaignActions
  extend ActiveSupport::Concern

  def index
    @campaigns = current_organization.campaigns
    respond_to do |format|
      format.html
      format.json { render json: @campaigns }
    end
  end

  def show
    @campaign = current_organization.campaigns.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: @campaign }
    end
  end
  
end
