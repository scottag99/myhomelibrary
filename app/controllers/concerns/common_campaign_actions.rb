module CommonCampaignActions
  extend ActiveSupport::Concern

  def index
    @campaigns = @organization.campaigns
    respond_to do |format|
      format.html
      format.json { render json: @campaigns }
    end
  end

  def show
    @campaign = @organization.campaigns.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @campaign }
    end
  end

  def edit
    @campaign = @organization.campaigns.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @campaign }
    end
  end

  def readers
    term = "%#{params[:term]}%".downcase
    @readers = Wishlist.select("teacher, reader_name, reader_age, reader_gender, sum(price) as wishlist_total, sum(amount) as donation_total, campaign_id, wishlists.id as id, count(catalog_entries.id) as book_count").joins([{:campaign => :organization}, "LEFT JOIN wishlist_entries ON wishlist_entries.wishlist_id = wishlists.id LEFT JOIN catalog_entries ON catalog_entries.id = wishlist_entries.catalog_entry_id", "LEFT JOIN donations ON donations.wishlist_id = wishlists.id"]).where("(lower(reader_name) like ? or lower(teacher) like ?) and organizations.id = ?", term, term, @organization).group(:teacher, :reader_name, :reader_age, :reader_gender, "campaign_id", "wishlists.id").order(:teacher, :reader_name)
    respond_to do |format|
      format.js { render 'common/campaigns/readers' }
    end
  end
end
