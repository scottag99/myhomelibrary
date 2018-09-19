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
      format.html { render 'common/form', locals: {form_title: 'Edit Volunteer', model: 'partners'} }
      format.json { render json: @partner }
    end
  end

  def update
    @partner = @organization.partners.find(params[:id])
    @partner.update!(partner_params)
    @partners = @organization.partners
    flash[:success] = "Thank you! Your volunteer was updated successfully."
    respond_to do |format|
      format.html { redirect_to url_for([get_namespace, @organization]) }
      format.json { render json: @partner }
    end
  end

  def destroy
    @organization.partners.destroy(params[:id])
    @partners = @organization.partners
    flash[:success] = "Thank you! Your volunteer was deleted successfully."

    respond_to do |format|
      format.html { redirect_to url_for([get_namespace, @organization]) }
      format.json { render json: @organization.partners.all}
    end
  end

end
