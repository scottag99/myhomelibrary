class Admin::HomeController < Admin::BaseController
  def index
    redirect_to admin_organizations_path
  end

  def reports
    wishlist = Wishlist.joins(campaign: :organization)
    wishlist = wishlist.where("wishlists.created_at > ?", params[:startDate]) unless params[:startDate].blank?
    wishlist = wishlist.where("wishlists.created_at < ?", params[:endDate]) unless params[:endDate].blank?

    donation = Donation.joins(wishlist: {campaign: :organization})
    donation = donation.where("donations.created_at > ?", params[:startDate]) unless params[:startDate].blank?
    donation = donation.where("donations.created_at < ?", params[:endDate]) unless params[:endDate].blank?

    case params[:sponsorshipType]
      when 'Classroom'
        donation = donation.where(is_classroom_sponsorship: true)
      when 'Grade'
        donation = donation.where(is_grade_sponsorship: true)
    end

    # Doing this before adding the includedOrganizations param so that we can
    # show all potential campaingns and orgs in the UI
    campaigns = wishlist.includes(:campaign).collect{|w| w.campaign}.uniq.sort_by{|c| c.name}
    organizations = Organization.where("id in (?)", campaigns.collect{|c|c.organization_id}).order(:name)

    if params[:includedOrganizations]
      wishlist = wishlist.where("campaigns.organization_id in (?)", params[:includedOrganizations])
      donation = donation.where("campaigns.organization_id in (?)", params[:includedOrganizations])
    end

    if params[:includedCampaigns]
      wishlist = wishlist.where("campaigns.id in (?)", params[:includedCampaigns])
      donation = donation.where("campaigns.id in (?)", params[:includedCampaigns])
    end

    @data = {
      :wishlists => wishlist.group(:organization_id).count,
      :donations => donation.group(:organization_id).sum(:amount),
      :sponsored_wishlists => wishlist.includes(:donations).where.not(donations: {id: nil}).group(:organization_id).count(),
      :campaigns => campaigns,
      :organizations => organizations
    }

    @data[:wishlists_total] = @data[:wishlists].inject(0){|sum, tuple| sum += tuple[1]}
    @data[:donations_total] = @data[:donations].inject(0){|sum, tuple| sum += tuple[1]}
    @data[:sponsored_wishlists_total] = @data[:sponsored_wishlists].inject(0){|sum, tuple| sum += tuple[1]}
  end
end
