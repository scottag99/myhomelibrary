require 'pack_resolver'

class Admin::CampaignsController < Admin::BaseController
  include CommonCampaignActions
  include GoogleSpreadsheet
  include PackResolver
  helper_method PackResolver.instance_methods
  before_action :set_organization

  def update
    @campaign = @organization.campaigns.find(params[:id])
    if @campaign.update_attributes(campaign_params)
      @campaigns = @organization.campaigns
      flash[:success] = "Thank you! Your Campaign was updated successfully."
      respond_to do |format|
        format.html { redirect_to admin_organization_url(@organization) }
        format.json { render json: @campaign }
      end
    else
      respond_to do |format|
        format.html { render 'common/form', locals: {form_title: 'Edit Campaign', model: 'campaigns'} }
      end
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
    headers = ['teacher*', 'reader_name*', 'grade*', 'reader_gender*', 'language', 'reading_level', 'reader_age', 'id']
    begin
      auth = login()
      ss = new_sheet("Roster Load for #{@organization.name}-#{@campaign.name}")
      data = [headers,
              Array.new(headers.size)<<'Instructions',
              Array.new(headers.size)<<"Use the table to the left to enter your roster data. Fields with a '*' are required.",
              Array.new(headers.size)<<'You can copy/paste and edit here until you are ready to upload.',
              Array.new(headers.size)<<'All changes to this sheet are saved automatically. You can stop and return to continue your work at any time.',
              Array.new(headers.size)<<'When ready, close this sheet and return to My Home Library to finish the upload process from the Campaign page.'
      ]
      add_data(ss, 'A1:Z15', data, auth)
      requests = []
      requests << create_hide_column_request(headers.size)
      requests << create_protect_rows_request(0 , 0 , 0, headers.size)
      requests << create_list_validation_request(1, 4000, headers.index('reader_gender*'), headers.index('reader_gender*')+1, ['M', 'F'])
      requests << create_list_validation_request(1, 4000, headers.index('language'), headers.index('language')+1, Language.where('is_disabled <> ?', true).order(:name).pluck(:name))
      requests << create_list_validation_request(1, 4000, headers.index('reading_level'), headers.index('reading_level')+1, ReadingLevel.where('is_disabled <> ?', true).order(:name).pluck(:name))
      batch_update(ss, requests, auth)
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

  def pack_order_sheet
    collate_pack_data
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

  def new_grade_sponsorship
    @campaign = @organization.campaigns.find(params[:id])
    @grades = @campaign.wishlists.group(:grade).count.map{|k,v| ["#{k} - Minimum: $#{30.0*v}", k]}
  end

  def create_grade_sponsorship
    @campaign = @organization.campaigns.find(params[:id])
    @wishlists = @campaign.wishlists.where(grade: params[:grade])
    if @wishlists.count > 0
      amt = params[:amount].to_d/@wishlists.count unless params[:amount].nil? || @wishlists.count == 0
      @wishlists.each do |w|
        @donation = w.donations.create!({:confirmation_code => "Offline Donation - #{Date.today.to_s(:db)}",
          :amount => amt,
          :is_classroom_sponsorship => false,
          :is_grade_sponsorship => true})
      end
    end

    respond_to do |format|
      format.html { redirect_to admin_organization_url(@organization) }
    end
  end

  def new_external_donation
    @campaign = @organization.campaigns.find(params[:id])
  end

  def create_external_donation
    @campaign = @organization.campaigns.find(params[:id])
    Donation.create!({:confirmation_code => "Offline Donation - #{Date.today.to_s(:db)}",
          :amount => params[:amount],
          :campaign_id => @campaign.id,
          :is_classroom_sponsorship => false,
          :is_grade_sponsorship => false})

    respond_to do |format|
      format.html { redirect_to admin_organization_url(@organization) }
    end
  end

private
  def set_organization
    @organization = Organization.find(params[:organization_id])
  end

  def campaign_params
    params.require(:campaign).permit(:name, :deadline, :ready_for_donations,
      :address, :can_edit_wishlists, :book_limit, {:catalog_ids => []}, :notes,
      :use_appreciation_notes, :prek_k_source_id, :first_fifth_source_id,
      :catalog_edition, :use_packs)
  end
end
