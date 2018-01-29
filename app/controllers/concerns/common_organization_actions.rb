module CommonOrganizationActions
  extend ActiveSupport::Concern

  def index
    @organizations = find_organizations
    calculate_org_total()
    respond_to do |format|
      format.html { render 'common/organizations/index' }
      format.json { render json: @organizations }
    end
  end

  def show
    @organization = find_organization
    respond_to do |format|
      format.html { render 'common/organizations/show' }
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

private

  def calculate_org_total
    orgs = find_organizations.collect{|o| o.id }
    @org_campaign_count = Campaign.joins(:organization).where("organizations.is_included = ? and organizations.id in (?)", true, orgs).count
    @org_wishlist_count = Wishlist.joins(campaign:[:organization]).where("organizations.is_included = ? and organizations.id in (?)", true, orgs).count
    @org_student_count = Wishlist.select(:external_id).joins(campaign:[:organization]).where("organizations.is_included = ? and organizations.id in (?)", true, orgs).distinct.count
    @org_donation_count = Donation.joins(wishlist: [{campaign: [:organization]}]).where("organizations.is_included = ? and organizations.id in (?)", true, orgs).count
    @org_donation_sum = Donation.joins(wishlist: [{campaign: [:organization]}]).where("organizations.is_included = ? and organizations.id in (?)", true, orgs).sum(:amount)
    @org_programdonation_sum = Donation.joins(campaign: [:organization]).where("organizations.is_included = ? and organizations.id in (?)", true, orgs).sum(:amount)
  end
end
