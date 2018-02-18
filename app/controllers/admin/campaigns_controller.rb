class Admin::CampaignsController < Admin::BaseController
  include CommonCampaignActions
  include GoogleSpreadsheet
  before_action :set_organization

  def update
    @campaign = @organization.campaigns.find(params[:id])
    @campaign.update!(campaign_params)
    @campaigns = @organization.campaigns
    flash[:success] = "Thank you! Your Campaign was updated successfully."
    respond_to do |format|
      format.html { redirect_to admin_organization_url(@organization) }
      format.json { render json: @campaign }
    end
  end

  def new
    @campaign = @organization.campaigns.new
    @campaign.can_edit_wishlists = true
    @campaign.book_limit = 6
    respond_to do |format|
      format.html { render 'common/form', locals: {form_title: 'New Campaign', model: 'campaigns'} }
      format.json { render json: @campaign }
    end
  end

  def create
    @campaign = @organization.campaigns.create!(campaign_params)
    begin
      auth = login()
      ss = new_sheet("Roster Load for #{@organization.name}-#{@campaign.name}")
      hide_column(ss, 7)
      data = [['teacher*', 'reader_name*', 'grade*', 'reader_age', 'reader_gender', 'external_id', 'id'],
              ['','','','','','','','Instructions'],
              ['','','','','','','',"Use the table to the left to enter your roster data. Fields with a '*' are required."],
              ['','','','','','','','You can copy/paste and edit here until you are ready to upload.'],
              ['','','','','','','','When ready, return to My Home Library to finish the upload process from the Campaign page.']
      ]
      range = 'A1:I5'
      add_data(ss, range, data, auth)
      @campaign.roster_data_reference = ss.spreadsheet_url
      @campaign.save
    rescue => ex
      Rails.logger.error(ex)
    end
    @campaigns = @organization.campaigns
    flash[:success] = "Thank you! Your Campaign was added successfully."
    respond_to do |format|
      format.html { redirect_to admin_organization_campaign_url(@organization, @campaign) }
      format.json { render json: @campaign }
    end
  end

  def destroy
    @campaign = @organization.campaigns.find(params[:id])
    unless @campaign.roster_data_reference.nil?
      begin
        id = @campaign.roster_data_reference.split("/").reverse[1]
        auth = login()
        delete(id, auth)
      rescue => ex
        Rails.logger.error(ex)
      end
    end
    @organization.campaigns.destroy(params[:id])
    @campaigns = @organization.campaigns
    flash[:success] = "Thank you! Your Campaign was deleted successfully."

    respond_to do |format|
      format.html { redirect_to admin_organization_url(@organization) }
      format.json { render json: @organization.campaigns.all}
    end
  end

  def order_sheet
    @campaign = @organization.campaigns.find(params[:id])
    @books = Book.joins({catalog_entries: [{wishlist_entries: [{wishlist: :campaign}]}, :catalog]}).where('wishlists.campaign_id = ?', @campaign).group('catalogs.source', :isbn, :title, 'catalog_entries.related_entry_id').order('catalogs.source', :title).count
    @prices = Book.joins({catalog_entries: [{wishlist_entries: [{wishlist: :campaign}]}, :catalog]}).where('wishlists.campaign_id = ?', @campaign).group('catalogs.source', :isbn, :title, 'catalog_entries.related_entry_id').order('catalogs.source', :title).sum('wishlist_entries.price')
    respond_to do |format|
      format.html
      format.json { render json: @campaign }
    end
  end

  def donations
    campaign = @organization.campaigns.find(params[:id])
    campaign.ready_for_donations = !campaign.ready_for_donations
    campaign.save
  end

  def wishlists
    campaign = @organization.campaigns.find(params[:id])
    campaign.can_edit_wishlists = !campaign.can_edit_wishlists
    campaign.save
  end

private
  def set_organization
    @organization = Organization.find(params[:organization_id])
  end

  def campaign_params
    params.require(:campaign).permit(:name, :deadline, :ready_for_donations, :address, :can_edit_wishlists, :book_limit, {:catalog_ids => []}, :notes)
  end
end
