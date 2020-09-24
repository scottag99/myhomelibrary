include GoogleSpreadsheet

module CommonWishlistActions
  extend ActiveSupport::Concern

  included do
    before_action :check_for_survey, only: :manage
  end

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
      format.js
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

  def take_survey
    @wishlist = current_campaign.wishlists.find(params[:id])
    config = find_survey_config(@wishlist).first
    @survey = config.survey
    @survey_response = @wishlist.build_survey_response(survey_answers: @survey.survey_questions.collect{|q| SurveyAnswer.new(survey_question: q)})

    respond_to do |format|
      format.html { render layout: 'survey', template: 'common/wishlists/take_survey' }
      format.json { render json: @survey }
    end
  end

  def survey_complete
    @organization = current_organization
    @campaign = current_campaign
    respond_to do |format|
      format.html { render layout: 'survey', template: 'common/wishlists/survey_complete' }
      format.json { render json: @survey }
    end
  end

  def save_response
    @wishlist = current_campaign.wishlists.find(params[:id])
    @survey_response = @wishlist.build_survey_response(survey_response_params)
    if @survey_response.save
      config = find_survey_config(@wishlist)
      if !config.first.nil? && config.first.is_control_group
        survey_complete_dest = url_for([:survey_complete, get_namespace, current_organization, current_campaign, @wishlist])
      else
        survey_complete_dest = url_for([:manage, get_namespace, current_organization, current_campaign, @wishlist])
      end
      respond_to do |format|
        format.html { redirect_to survey_complete_dest }
        format.json { render json: @survey_response }
      end
    else
      respond_to do |format|
        format.html { render 'common/wishlists/take_survey' }
        format.json { render json: @survey_response }
      end
    end
  end

  def edit
    @wishlist = current_campaign.wishlists.find(params[:id])

    respond_to do |format|
      format.html { render 'common/form', locals: {form_title: 'Edit Wishlist', model: 'wishlists'} }
      format.js
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
        rows = get_data(ss, 'A1:Z1', auth)
        columns = rows.values.shift
        required_fields = columns.reduce([]){|a, c| a.push(c.gsub(/\*/, '').strip.to_sym) if c.ends_with?('*'); a}
        header = columns.collect{|v| v.gsub(/\*/, '').strip}
        range = "A2:#{('A'..'Z').to_a[header.size-1]}"
        roster = get_data(ss, range, auth)
        idx = 0
        valid_rows = []
        error_rows = []
        roster.values.each do |row_data|
          idx += 1
          while(row_data.size < header.size)
            row_data << ""
          end
          row = Hash[[header, row_data].transpose]
          # Only process rows without an ID
          if row['id'].empty?
            row.each{|k,v| row[k] = v.strip if v.is_a? String }
            w = current_campaign.wishlists.find_by(reader_name: row['reader_name'], teacher: row['teacher'])
            if w.nil?
              w = current_campaign.wishlists.create(row.to_hash)
            else
              w.update(row.to_hash.except('id'))
            end
            w.import_required = required_fields
            if w.save
              row_data[header.index('id')] = w.id
              valid_rows << idx
            else
              flash[:notice] = "Some rows had errors, please correct and upload again to fix."
              error_rows << idx
            end
          end
        end
        add_data(ss, range, roster.values, auth)

        i = 0
        start_row = valid_rows[i]
        requests = []
        while i < valid_rows.size
          if i+1 == valid_rows.size || (valid_rows[i+1] - valid_rows[i] != 1)
            requests << create_color_rows_request(start_row, valid_rows[i], 0, header.size, 0.8509804, 0.91764706, 0.827451, 1.0)
            start_row = valid_rows[i+1]
          end
          i += 1
        end

        i = 0
        start_row = error_rows[i]
        while i < error_rows.size
          if i+1 == error_rows.size || (error_rows[i+1] - error_rows[i] != 1)
            requests << create_color_rows_request(start_row, error_rows[i], 0, header.size, 0.9019608, 0.72156864, 0.6862745, 1.0)
            start_row = error_rows[i+1]
          end
          i += 1
        end
        batch_update(ss, requests, auth)
      rescue => ex
        Rails.logger.error(ex)
        flash[:notice] = ex.message
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
    params.require(:wishlist).permit(:reader_name, :reader_age, :reader_gender, :teacher, :grade, :language_id, :reading_level_id, :grl, :external_id, :is_delivered, :is_consent_given)
  end

  def survey_response_params
    params.require(:survey_response).permit(:survey_id, survey_answer_ids: [], survey_answers_attributes: [:value, :survey_question_id])
  end

  def check_for_survey
    w = Wishlist.find(params[:id])
    if w.is_consent_given
      configs = find_survey_config(w)
      if configs.count > 0
        if w.survey_response.nil?
          redirect_to get_take_survey_url(w)
        elsif configs.first.is_control_group
          redirect_to url_for([:survey_complete, get_namespace, current_organization, current_campaign, w])
        end
      end
    end
  end

  def find_survey_config(wishlist)
    current_campaign.campaign_survey_configs.where("teacher ilike ? and (is_disabled = ? or is_disabled is NULL)", wishlist.teacher, false)
  end
end
