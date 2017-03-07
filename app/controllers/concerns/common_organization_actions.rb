module CommonOrganizationActions
  extend ActiveSupport::Concern

  def index
    @organizations = find_organizations
    respond_to do |format|
      format.html
      format.json { render json: @organizations }
    end
  end

  def show
    @organization = find_organization
    respond_to do |format|
      format.html
      format.json { render json: @organization }
    end
  end

  def edit
    @organization = find_organization
    respond_to do |format|
      format.html { render 'common/form', locals: {form_title: 'Edit Organization', model: 'organizations'} }
      format.json { render json: @organization }
    end
  end
end
