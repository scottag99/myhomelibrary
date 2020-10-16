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
    select_text = "teacher, reader_name, reader_age, reader_gender, grade, "\
                  "language_id, languages.name as language, "\
                  "reading_level_id, reading_levels.name as reading_level, "\
                  "is_consent_given, campaign_id, wishlists.id as id, "\
                  "COALESCE(book_count, 0) as book_count, is_delivered, grl, external_id"
    grouping = [:teacher, :reader_name, :reader_age, :reader_gender, :grade,
      :language_id, 'languages.name', :reading_level_id, 'reading_levels.name',
      :is_consent_given, "campaign_id", "wishlists.id", "book_count",
      :is_delivered, :grl, :external_id]
    if get_role == 'admin'
      select_text += ", COALESCE(wishlist_total, 0) as wishlist_total, COALESCE(donation_total, 0) as donation_total"
      grouping = grouping + ['wishlist_total', 'donation_total']
    end
    @readers = Wishlist
      .select(select_text)
      .joins([:campaign, "LEFT JOIN languages ON languages.id = wishlists.language_id",
        "LEFT JOIN reading_levels ON reading_levels.id = wishlists.reading_level_id",
        "LEFT JOIN (select count(*) as book_count, sum(price) as wishlist_total, wishlist_id FROM wishlist_entries GROUP BY wishlist_id) wishlist_entries ON wishlist_entries.wishlist_id = wishlists.id",
        "LEFT JOIN (select sum(amount) as donation_total, wishlist_id FROM donations GROUP BY wishlist_id) donations ON donations.wishlist_id = wishlists.id"])
      .where("(lower(reader_name) like ? or lower(teacher) like ?) and campaign_id = ?", term, term, @campaign)
      .group(grouping)
      .order(params[:sort])
      .limit(params[:limit])
      .offset(params[:offset])
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

  def distribution
    # grade sort: grade, teacher, student
    #       fields: Grade, teacher, student, EZ-ID, Pack Type
    # teacher sort: teacher, student
    #         fields: teacher, grade, student, EZ-ID, Pack Type
    # student sort: student
    #         fields: Student, teacher, grade, EZ-ID, Pack Type
    case params[:sort]
      when 'teacher'
        @sort = ['teacher', 'reader_name']
        @fields = ['teacher', 'grade', 'reader_name', 'ezid', 'pack_type']
        @sort_type = 'teacher'
      when 'student'
        @sort = ['reader_name']
        @fields = ['reader_name', 'teacher', 'grade', 'ezid', 'pack_type']
        @sort_type = 'student'
      else
        @sort = ["case when grade='PreK' then '0PreK' when grade='K' then '1K' else grade end", 'teacher', 'reader_name']
        @fields = ['grade', 'teacher', 'reader_name', 'ezid', 'pack_type']
        @sort_type = 'grade'
    end
    @campaign = @organization.campaigns.find(params[:id])
    respond_to do |format|
      format.html { render 'common/campaigns/distribution' }
    end
  end

  def export
    campaign = @organization.campaigns.find(params[:id])
    records = WishlistEntry.joins(:wishlist).where('wishlists.campaign_id = ?', campaign)

    temp_csv = Tempfile.new
    begin
      CSV.open(temp_csv.path, mode = "wb", headers: true) do |csv|
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
      send_file temp_csv, filename: "#{@organization.name}-#{campaign.name}-WishListReport.csv", type: 'application/octet-stream'
    ensure
      temp_csv.close
      # when un-commented...downloads fail
      #temp_csv.unlink   # deletes the temp file
    end

  end

  def book_count
    campaign = @organization.campaigns.find(params[:id])
    records = Wishlist.joins(wishlist_entries: [{catalog_entry: [:book, :catalog]}]).where(:campaign => campaign).group(:source, :isbn, :title, :author, 'wishlist_entries.price').order('catalogs.source', 'books.title').count

    temp_csv = Tempfile.new
    begin
      CSV.open(temp_csv.path, mode = "wb", headers: true) do |csv|
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
      send_file temp_csv, filename: "#{@organization.name}-#{campaign.name}-BookCountReport.csv", type: 'application/octet-stream'
    ensure
      temp_csv.close
      # when un-commented...downloads fail
      #temp_csv.unlink   # deletes the temp file
    end
  end

  def exportroster
    campaign = @organization.campaigns.find(params[:id])

    temp_csv = Tempfile.new
    begin
      CSV.open(temp_csv.path, mode = "wb", headers: true) do |csv|
        csv << ['School_Name', 'Campaign_name', 'Campaign_Deadline', 'Teacher', 'Student', 'Gender', 'Age']

        campaign.wishlists.each do |wishlist|
          csv << [@organization.name, campaign.name, campaign.deadline, wishlist.teacher, wishlist.reader_name, wishlist.reader_gender, wishlist.reader_age]
        end
      end
      send_file temp_csv, filename: "#{@organization.name}-#{campaign.name}-ClassRosterReport.csv", type: 'application/octet-stream'
    ensure
      temp_csv.close
      # when un-commented...downloads fail
      #temp_csv.unlink   # deletes the temp file
    end
  end

  def export_survey
    campaign = @organization.campaigns.find(params[:id])
    # this quirky looking thing in front of student is the BOM to force Excel to honor the UTF-8 encoding
    base_header = ["\uFEFF" + 'Student', 'Gender', 'Grade', 'Student ID', 'Teacher', 'School', 'Campaign', 'Campaign date', 'Survey']
    wishlists = Wishlist.joins(:survey_response).includes([wishlist_entries: {catalog_entry: :book}, survey_response: [:survey, survey_answers: :survey_question]]).where(campaign_id: campaign.id)
    grouped = {}
    wishlists.each do |wishlist|
      key = wishlist.survey_response.survey.name
      books = wishlist.wishlist_entries.collect{|e| e.catalog_entry.book.isbn}
      unless grouped.has_key?(key)
        header = base_header + wishlist.survey_response.survey_answers.order(:survey_question_id).collect{|answer| answer.survey_question.question}
        grouped = {key => {header: header, data: [], book_count: books.size}}.merge(grouped)
      end
      base_values = [wishlist.reader_name, wishlist.reader_gender, wishlist.grade, wishlist.external_id, wishlist.teacher, @organization.name, campaign.name, campaign.deadline, key]
      grouped[key][:data] << (base_values + wishlist.survey_response.survey_answers.order(:survey_question_id).collect{|answer| answer.value} + books)
      grouped[key][:book_count] = [books.size, grouped[key][:book_count]].max
    end

    zip_file = Tempfile.new
    begin
      Zip::File.open(zip_file, Zip::File::CREATE) do |zipfile|
        grouped.each do |key, value|
          temp_csv = Tempfile.new
          begin
            CSV.open(temp_csv.path, mode = "wb", headers: true) do |csv|
              csv << (value[:header] + value[:book_count].times.inject([]){|arr, idx| arr << "Book #{idx+1}"})

              value[:data].each do |row|
                csv << row
              end
            end
            zipfile.add("#{key.parameterize}.csv", temp_csv.path)
          ensure
            temp_csv.close
          end
        end
      end
      send_file zip_file, filename: "#{@organization.name}-#{campaign.name}-SurveyData.zip", type: 'application/zip'
    ensure
      zip_file.close
    end

  end

  def inventory
    collate_pack_data
  end

  def collate_pack_data
    @campaign = @organization.campaigns.find(params[:id])
    @data = { 'Scholastic': {}, 'BBHLF': {}, 'Unknown': {} }
    @campaign.wishlists.find_each(batch_size: 100) do |wishlist|
      pack = resolve_pack(@campaign, wishlist)
      entry = case pack[:ezid][0]
        when 'S' then @data[:Scholastic]
        when 'R' then @data[:BBHLF]
        when 'U' then @data[:Unknown]
      end
      pack_data = entry[pack[:ezid]] || { pack_type: pack[:pack_type], count: 0 }
      pack_data[:count] += 1
      entry[pack[:ezid]] = pack_data
    end
  end
end
