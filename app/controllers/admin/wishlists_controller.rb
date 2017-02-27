require 'roo'

class Admin::WishlistsController < Admin::BaseController
  include CommonWishlistActions

  def update
    @wishlist = current_campaign.wishlists.find(params[:id])
    @wishlist.update!(wishlist_params)
    respond_to do |format|
      format.html { redirect_to admin_organization_campaign_url(current_organization, current_campaign) }
      format.json { render json: @wishlist }
    end
  end

  def create
    @wishlist = current_campaign.wishlists.create!(wishlist_params)
    respond_to do |format|
      format.html { redirect_to admin_organization_campaign_url(current_organization, current_campaign) }
      format.json { render json: @wishlist }
    end
  end

  def edit_upload
    @campaign = current_campaign
    respond_to do |format|
      format.js { render 'common/wishlists/edit_upload' }
    end
  end

  def upload
    uploaded_io = params[:wishlist][:upload]

    parser = Roo::Spreadsheet.open(uploaded_io.path)
    header = parser.row(1)
    (2..parser.last_row).each do |i|
      row = Hash[[header, parser.row(i)].transpose]
      row.each{|k,v| row[k] = v.strip if v.is_a? String }
      current_campaign.wishlists.create!(row.to_hash)
    end

    respond_to do |format|
      format.html { redirect_to admin_organization_campaign_url(current_organization, current_campaign) }
    end
  end

  def download
    file_name = "#{current_campaign.organization.name.parameterize}-#{current_campaign.name.parameterize}.csv"
    content = "#{current_campaign.organization.name},#{current_campaign.name}\r\n"
    content += "Teacher Name,Student Name,Grade\r\n"
    current_campaign.wishlists.each do |w|
      content += "\"#{w.teacher}\",\"#{w.reader_name}\",#{w.grade}\r\n"
    end

    send_data content, :filename => file_name
  end

private
    def current_organization
      Organization.find(params[:organization_id])
    end

    def current_campaign
      current_organization.campaigns.find(params[:campaign_id])
    end

    def get_add_url(wishlist)
      admin_organization_campaign_wishlist_wishlist_entries_url(current_organization, current_campaign, wishlist)
    end

    def get_delete_url(wishlist)
      admin_organization_campaign_wishlist_wishlist_entry_url(current_organization, current_campaign, wishlist, ':id')
    end

    def get_campaign_url
      admin_organization_campaign_url(current_organization, current_campaign)
    end
end
