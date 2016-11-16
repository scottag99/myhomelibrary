module CommonPartnerActions
  extend ActiveSupport::Concern

  def index
    @partners = @organization.partners
    respond_to do |format|
      format.html
      format.json { render json: @partners }
    end
  end

  def show
    @partner = @organization.partners.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @partner }
    end
  end

  def edit
    @partner = @organization.partners.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @partner }
    end
  end

end
