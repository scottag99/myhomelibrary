class Admin::OrganizationsController < Admin::BaseController
  include CommonOrganizationActions

  def new
    @organization = Organization.new
    respond_to do |format|
      format.html { render 'common/form', locals: {form_title: 'New Organization', model: 'organizations'} }
      format.json { render json: @organization }
    end
  end

  def update
    @organization = Organization.find(params[:id])
    @organization.update!(org_params)
    respond_to do |format|
      format.html { redirect_to admin_organizations_url }
      format.json { render json: @organization }
    end
  end

  def create
    @organization = Organization.create!(org_params)
    flash[:success] = "Thank you! Your Organization has been added."
    respond_to do |format|
      format.html { redirect_to admin_organization_url(@organization) }
      format.json { render json: @organization }
    end
  end

  def destroy
    Organization.destroy(params[:id])
    flash[:success] = "Delete successful."
    respond_to do |format|
      format.html { redirect_to admin_organizations_url }
      format.json { render json: Organization.all}
    end
  end

  def included
    @organization = Organization.find(params[:id])
    @organization.is_included = !@organization.is_included
    @organization.save
    calculate_org_total()
  end

private
  def find_organizations
    if params[:begin_date] && params[:end_date]
      Organization.joins(:campaigns).where('campaigns.deadline between ? and ?', params[:begin_date], params[:end_date]).order('organizations.name ASC')
    else
      Organization.order('name ASC')
    end
  end

  def find_organization
    Organization.find(params[:id])
  end

  def org_params
    params.require(:organization).permit(:name, :contact_name, :contact_email, :slug)
  end

end
