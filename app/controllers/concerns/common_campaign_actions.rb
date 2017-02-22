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
    @campaign = @organization.campaigns.find(params[:id])

    term = "%#{params[:term]}%".downcase
    select_text = "teacher, reader_name, reader_age, reader_gender, campaign_id, wishlists.id as id, count(catalog_entries.id) as book_count"
    grouping = [:teacher, :reader_name, :reader_age, :reader_gender, "campaign_id", "wishlists.id"]
    if get_role == 'admin'
      select_text += ", sum(price) as wishlist_total, sum(amount) as donation_total"
      grouping = grouping + [:amount, :price]
    end
    @readers = Wishlist.select(select_text).joins([:campaign, "LEFT JOIN wishlist_entries ON wishlist_entries.wishlist_id = wishlists.id LEFT JOIN catalog_entries ON catalog_entries.id = wishlist_entries.catalog_entry_id", "LEFT JOIN donations ON donations.wishlist_id = wishlists.id"]).where("(lower(reader_name) like ? or lower(teacher) like ?) and campaign_id = ?", term, term, @campaign).group(grouping).order(params[:sort]).limit(params[:limit]).offset(params[:offset])
    respond_to do |format|
      format.js { render 'common/campaigns/readers' }
      format.json { render json: @readers }
    end
  end
end
