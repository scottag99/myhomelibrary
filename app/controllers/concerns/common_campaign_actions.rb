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
    select_text = "teacher, reader_name, reader_age, reader_gender, grade, campaign_id, wishlists.id as id, COALESCE(book_count, 0) as book_count, is_delivered, grl, external_id"
    grouping = [:teacher, :reader_name, :reader_age, :reader_gender, :grade, "campaign_id", "wishlists.id", "book_count", :is_delivered, :grl, :external_id]
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

  def pick_list
    @campaign = @organization.campaigns.find(params[:id])
    @wishlists = @campaign.wishlists.order(:teacher, :reader_name)
    respond_to do |format|
      format.html { render 'common/campaigns/pick_list' }
      format.json { render json: @campaign }
    end
  end

  def export
    campaign = @organization.campaigns.find(params[:id])
    records = WishlistEntry.joins(:wishlist).where('wishlists.campaign_id = ?', campaign)

    data = CSV.generate(headers: true) do |csv|
      headers = ['School_Name', 'Campaign_name', 'Teacher', 'Student', 'Grade', 'Age', 'Title', 'Author', 'Catalog', 'ISBN']
      if get_role == 'admin'
        headers << 'Unit_Price'
      end
      csv << headers

      records.each do |we|
        row = [@organization.name, campaign.name, we.wishlist.teacher, we.wishlist.reader_name, we.wishlist.grade, we.wishlist.reader_age, we.catalog_entry.book.title, we.catalog_entry.book.author, we.catalog_entry.catalog.source, we.catalog_entry.book.isbn]
        if get_role == 'admin'
          row << we.catalog_entry.price
        end
        csv << row
      end
    end
    send_data data, filename: "#{@organization.name}-#{campaign.name}-WishListReport.csv"
  end

  def book_count
    campaign = @organization.campaigns.find(params[:id])
    records = Wishlist.joins(wishlist_entries: [{catalog_entry: [:book, :catalog]}]).where(:campaign => campaign).group(:source, :isbn, :title, :author, 'wishlist_entries.price').order('catalogs.source', 'books.title').count

    data = CSV.generate(headers: true) do |csv|
      headers = ['School_Name', 'Campaign_name', 'Title', 'Author', 'Catalog', 'ISBN', 'Order_QTY']
      if get_role == 'admin'
        headers << 'Unit_Price'
      end
      csv << headers

      records.each do |key, count|
        row = [@organization.name, campaign.name, key[2], key[3], key[0], key[1], count]
        if get_role == 'admin'
          row << key[4]
        end
        csv << row
      end
    end
    send_data data, filename: "#{@organization.name}-#{campaign.name}-BookCountReport.csv"
  end

  # def export
  #   campaign = @organization.campaigns.find(params[:id])
  #   records = Wishlist.joins(wishlist_entries: [{catalog_entry: [:book, :catalog]}]).where(:campaign => campaign).group(:source, :teacher, :grade, :isbn, :title, 'wishlist_entries.price').order('catalogs.source', 'wishlists.grade', 'wishlists.teacher', 'books.title').count
  #
  #   data = CSV.generate(headers: true) do |csv|
  #     csv << ['School_Name', 'Campaign_name', 'Teacher', 'Grade', 'Catalog', 'ISBN', 'Title', 'Unit_Price', 'QTY', 'Subtotal']
  #
  #     records.each do |key, count|
  #       csv << [@organization.name, campaign.name, key[1], key[2], key[0], key[3], key[4], key[5], count, key[5]*count]
  #     end
  #   end
  #   send_data data, filename: "#{@organization.name}-#{campaign.name}-WishListReport.csv"
  # end

  def exportroster
    campaign = @organization.campaigns.find(params[:id])

    data = CSV.generate(headers: true) do |csv|
      csv << ['School_Name', 'Campaign_name', 'Campaign_Deadline', 'Teacher', 'Student', 'Gender', 'Age']

      campaign.wishlists.each do |wishlist|
        csv << [@organization.name, campaign.name, campaign.deadline, wishlist.teacher, wishlist.reader_name, wishlist.reader_gender, wishlist.reader_age]
      end
    end
    send_data data, filename: "#{@organization.name}-#{campaign.name}-ClassRosterReport.csv"
  end
end
