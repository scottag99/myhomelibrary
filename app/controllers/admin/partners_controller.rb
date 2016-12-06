class Admin::PartnersController < Admin::BaseController
  include CommonPartnerActions
  before_action :set_organization

  def update
    @partner = @organization.partners.find(params[:id])
    @partner.update!(partner_params)
    @partners = @organization.partners
    flash[:success] = "Thank you! Your volunteer was updated successfully."
    respond_to do |format|
      format.html { redirect_to admin_organization_url(@organization) }
      format.json { render json: @partner }
    end
  end

  def new
    @partner = @organization.partners.new
    @partner.active = true
    respond_to do |format|
      format.html
      format.json { render json: @partner }
    end
  end

  def create
    @partner = @organization.partners.create!(partner_params)
    @partners = @organization.partners
    flash[:success] = "Thank you! Your volunteer was added successfully."
    respond_to do |format|
      format.html { redirect_to admin_organization_url(@organization) }
      format.json { render json: @partner }
    end
  end

  def destroy
    @organization.partners.destroy(params[:id])
    @partners = @organization.partners
    flash[:success] = "Thank you! Your volunteer was deleted successfully."

    respond_to do |format|
      format.html { redirect_to admin_organization_url(@organization) }
      format.json { render json: @organization.partners.all}
    end
  end

private
  def set_organization
    @organization = Organization.find(params[:organization_id])
  end

  def partner_params
    params.require(:partner).permit(:name, :email, :active)
  end
end
