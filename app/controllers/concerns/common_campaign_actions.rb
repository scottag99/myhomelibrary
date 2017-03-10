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
      format.html { render 'common/form', locals: {form_title: 'Edit Campaign', model: 'campaigns'} }
      format.json { render json: @campaign }
    end
  end

  def readers
    @campaign = @organization.campaigns.find(params[:id])

    term = "%#{params[:term]}%".downcase
    select_text = "teacher, reader_name, reader_age, reader_gender, grade, campaign_id, wishlists.id as id, COALESCE(book_count, 0) as book_count, grl"
    grouping = [:teacher, :reader_name, :reader_age, :reader_gender, :grade, "campaign_id", "wishlists.id", "book_count", :grl]
    if get_role == 'admin'
      select_text += ", COALESCE(wishlist_total, 0) as wishlist_total, COALESCE(donation_total, 0) as donation_total"
      grouping = grouping + ['wishlist_total', 'donation_total']
    end
    @readers = Wishlist.select(select_text).joins([:campaign, "LEFT JOIN (select count(*) as book_count, sum(price) as wishlist_total, wishlist_id FROM wishlist_entries GROUP BY wishlist_id) wishlist_entries ON wishlist_entries.wishlist_id = wishlists.id", "LEFT JOIN (select sum(amount) as donation_total, wishlist_id FROM donations GROUP BY wishlist_id) donations ON donations.wishlist_id = wishlists.id"]).where("(lower(reader_name) like ? or lower(teacher) like ?) and campaign_id = ?", term, term, @campaign).group(grouping).order(params[:sort]).limit(params[:limit]).offset(params[:offset])
    respond_to do |format|
      format.js { render 'common/campaigns/readers' }
      format.json { render json: @readers }
    end
  end
end
