include GoogleSpreadsheet

module CommonWishlistActions
  extend ActiveSupport::Concern

  def index
    @wishlists = current_campaign.wishlists
    @campaign = current_campaign
    respond_to do |format|
      format.html
      format.json { render json: @wishlists }
    end
  end

  def show
    @wishlist = current_campaign.wishlists.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: @wishlist }
    end
  end

  def manage
    @wishlist = current_campaign.wishlists.find(params[:id])
    @add_url = get_add_url(@wishlist)
    @delete_url = get_delete_url(@wishlist)
    @back_url = get_done_url(@wishlist)
    previous_books = [0]
    unless @wishlist.external_id.blank?
      previous_books = previous_books + CatalogEntry.joins(:wishlist_entries => {:wishlist => :campaign}).where("wishlists.id <> ? and campaigns.organization_id = ? and wishlists.external_id = ?", @wishlist, current_campaign.organization_id, @wishlist.external_id).collect{|ce| ce.book_id}
    end
    @active_books = CatalogEntry.joins({:catalog => :campaigns}).includes(:book).where('catalogs.active = ? and disabled = ? and book_id NOT IN (?) and campaigns.id = ?', true, false, previous_books, current_campaign).all

    respond_to do |format|
      format.html { render 'common/wishlists/manage'}
      format.json { render json: @wishlist }
    end
  end

  def edit
    @wishlist = current_campaign.wishlists.find(params[:id])

    respond_to do |format|
      format.html { render 'common/form', locals: {form_title: 'Edit Wishlist', model: 'wishlists'} }
      format.json { render json: @wishlist }
    end
  end

  def new
    @wishlist = current_campaign.wishlists.new
    respond_to do |format|
      format.html { render 'common/form', locals: {form_title: 'New Wishlist', model: 'wishlists'} }
      format.json { render json: @wishlist }
    end
  end

  def edit_multiple
    @wishlists = current_campaign.wishlists.find(params[:wishlists_ids].split(',').map(&:to_i))
    @campaign = current_campaign
    respond_to do |format|
      format.js { render 'common/wishlists/edit_multiple' }
      format.json { render json: @wishlists }
    end
  end

  def update_multiple
    @wishlists = current_campaign.wishlists.find(params[:wishlists_ids].split(',').map(&:to_i))
    @wishlists.each do |wishlist|
      wishlist.update_attributes!(wishlist_params.reject { |k,v| v.blank? })
    end
    flash[:notice] = "Updated wishlists!"
    redirect_to get_campaign_url
  end

  def edit_upload
    @campaign = current_campaign
    respond_to do |format|
      format.js { render 'common/wishlists/edit_upload' }
    end
  end

  def upload
    unless current_campaign.roster_data_reference.nil?
      begin
        id = current_campaign.roster_data_reference.split("/").reverse[1]
        auth = login()
        ss = get_sheet(id, auth)
        rows = get_data(ss, 'A1:Z')
        header = rows.values.shift
        rows.values.each do |row_data|
          row = Hash[[header, row_data].transpose]
          row.each{|k,v| row[k] = v.strip if v.is_a? String }
          current_campaign.wishlists.create!(row.to_hash)
        end
      rescue => ex
        Rails.logger.error(ex)
      end
    end
    #uploaded_io = params[:wishlist][:upload]

    #parser = Roo::Spreadsheet.open(uploaded_io.path)
    # header = parser.row(1)
    # (2..parser.last_row).each do |i|
    #   row = Hash[[header, parser.row(i)].transpose]
    #   row.each{|k,v| row[k] = v.strip if v.is_a? String }
    #   current_campaign.wishlists.create!(row.to_hash)
    # end

    respond_to do |format|
      format.html { redirect_to url_for([get_namespace, current_organization, current_campaign]) }
    end
  end

  def toggle_delivered
    @wishlist = current_campaign.wishlists.find(params[:id])
    @wishlist.is_delivered = !@wishlist.is_delivered
    @wishlist.save
    redirect_to get_campaign_url
  end

  def download
    file_name = "#{current_campaign.organization.name.parameterize}-#{current_campaign.name.parameterize}-LabelSheet.csv"
    content = "#{current_campaign.organization.name},#{current_campaign.name}\r\n"
    content += "Teacher Name,Student Name,Grade\r\n"
    current_campaign.wishlists.each do |w|
      content += "\"#{w.teacher}\",\"#{w.reader_name}\",#{w.grade}\r\n"
    end

    send_data content, :filename => file_name
  end

private
  def wishlist_params
    params.require(:wishlist).permit(:reader_name, :reader_age, :reader_gender, :teacher, :grade, :grl, :external_id, :is_delivered)
  end
end
