class Admin::CampaignsController < Admin::BaseController
  include CommonCampaignActions
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
    respond_to do |format|
      format.html { render 'common/form', locals: {form_title: 'New Campaign', model: 'campaigns'} }
      format.json { render json: @campaign }
    end
  end

  def create
    @campaign = @organization.campaigns.create!(campaign_params)
    @campaigns = @organization.campaigns
    flash[:success] = "Thank you! Your Campaign was added successfully."
    respond_to do |format|
      format.html { redirect_to admin_organization_campaign_url(@organization, @campaign) }
      format.json { render json: @campaign }
    end
  end

  def destroy
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

  def pick_list
    @campaign = @organization.campaigns.find(params[:id])
    @wishlists = @campaign.wishlists.order(:teacher, :reader_name)
    respond_to do |format|
      format.html
      format.json { render json: @campaign }
    end
  end

  def export
    campaign = @organization.campaigns.find(params[:id])
    records = Wishlist.joins(wishlist_entries: [{catalog_entry: [:book, :catalog]}]).where(:campaign => campaign).group(:source, :teacher, :grade, :isbn, :title, 'wishlist_entries.price').order('catalogs.source', 'wishlists.grade', 'wishlists.teacher', 'books.title').count

    data = CSV.generate(headers: true) do |csv|
      csv << ['School_Name', 'Campaign_name', 'Teacher', 'Grade', 'Catalog', 'ISBN', 'Title', 'Unit_Price', 'QTY', 'Subtotal']

      records.each do |key, count|
        csv << [@organization.name, campaign.name, key[1], key[2], key[0], key[3], key[4], key[5], count, key[5]*count]
      end
    end
    send_data data, filename: "#{@organization.name}-#{campaign.name}.csv"
  end
private
  def set_organization
    @organization = Organization.find(params[:organization_id])
  end

  def campaign_params
    params.require(:campaign).permit(:name, :deadline, :ready_for_donations, :address, :can_edit_wishlists, :book_limit, {:catalog_ids => []})
  end
end
