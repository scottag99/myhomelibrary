require 'nokogiri'
class Admin::CatalogsController < Admin::BaseController
  include GoogleSpreadsheet

  def index
    @catalogs = Catalog.all
    respond_to do |format|
      format.html
      format.json { render json: @catalogs }
    end
  end

  def show
    @catalog = Catalog.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: @catalog }
    end
  end

  def new
    @catalog = Catalog.new
    respond_to do |format|
      format.html { render 'common/form', locals: {form_title: 'New Catalog', model: 'catalogs'} }
      format.json { render json: @catalog }
    end
  end

  def edit
    @catalog = Catalog.find(params[:id])
    respond_to do |format|
      format.html { render 'common/form', locals: {form_title: 'Edit Catalog', model: 'catalogs'}  }
      format.json { render json: @catalog }
    end
  end

  def update
    @catalog = Catalog.find(params[:id])
    @catalog.update!(catalog_params)
    flash[:notice] = "Catalog updated."
    @catalogs = Catalog.all
    respond_to do |format|
      format.html { render "index" }
      format.json { render json: @catalog }
    end
  end

  def create
    @catalog = Catalog.create!(catalog_params)
    headers = ['title*', 'author*', 'description*', 'isbn*', 'level', 'cover_image_url*', 'price*',
      'is_bilingual', 'is_chapter', 'year', 'ar_points', 'ar_level', 'grl', 'dra', 'id']
    begin
      auth = login()
      ss = new_sheet("Book Load for #{@catalog.name} (#{@catalog.source})")
      hide_column(ss, headers.size)
      data = [headers,
              Array.new(headers.size)<<'Instructions',
              Array.new(headers.size)<<"Use the table to the left to enter your book data. Fields with a '*' are required.",
              Array.new(headers.size)<<'You can copy/paste and edit here until you are ready to upload.',
              Array.new(headers.size)<<'All changes to this sheet are saved automatically. You can stop and return to continue your work at any time.',
              Array.new(headers.size)<<'When ready, close this sheet and return to My Home Library to finish the upload process from the Catalog page.'
      ]
      range = 'A1:Z15'
      add_data(ss, range, data, auth)
      @catalog.book_data_reference = ss.spreadsheet_url
      @catalog.save
    rescue => ex
      Rails.logger.error(ex)
    end

    respond_to do |format|
      format.html { render "show" }
      format.json { render json: @catalog }
    end
  end

  def destroy
    @catalog = Catalog.find(params[:id])
    @catalog.destroy()
    if @catalog.errors.any?
      @catalog.errors.full_messages.each do |message|
        flash[:warning] = message
      end
    end
    @catalogs = Catalog.all
    respond_to do |format|
      format.html { render "index" }
      format.json { render json: @catalogs}
    end
  end

  def export
    @catalog = Catalog.find(params[:id])

    data = CSV.generate(headers: true) do |csv|
      csv << ['Title', 'Author', 'Description', 'Publisher', 'DRA', 'Bilingual', 'Chapters']

      @catalog.catalog_entries.each do |ce|
        csv << [ce.book.title, ce.book.author, ce.book.description, @catalog.source, ce.book.dra, ce.book.is_bilingual, ce.book.is_chapter]
      end
    end
    send_data data, filename: "#{@catalog.name}-CatalogReport.csv"
  end

  def active
    @catalog = Catalog.find(params[:id])
    @catalog.active = !@catalog.active
    @catalog.save
  end

  def upload
    @catalog = Catalog.find(params[:id])
    unless @catalog.book_data_reference.nil?
      begin
        id = @catalog.book_data_reference.split("/").reverse[1]
        auth = login()
        ss = get_sheet(id, auth)
        rows = get_data(ss, 'A1:Z1', auth)
        header = rows.values.shift.collect{|v| v.gsub(/\*/, '').strip}
        range = "A2:#{('A'..'Z').to_a[header.size-1]}"
        books = get_data(ss, range, auth)
        idx = 0
        valid_rows = []
        error_rows = []
        books.values.each do |row_data|
          idx += 1
          while(row_data.size < header.size)
            row_data << ""
          end
          row = Hash[[header, row_data].transpose]
          # Only process rows without an ID
          if row['id'].empty?
            row.each{|k,v| row[k] = v.strip if v.is_a? String }
            book = Book.where(isbn: row['isbn']).first_or_initialize
            book.attributes = row.to_hash.except('price', 'id')
            book.save
            w = @catalog.catalog_entries.create(book: book, price: row['price'])
            if w.save
              row_data[header.index('id')] = w.id
              valid_rows << idx
            else
              flash[:notice] = "Some rows had errors, please correct and upload again to fix."
              error_rows << idx
            end
          end
        end
        add_data(ss, range, books.values, auth)

        i = 0
        start_row = valid_rows[i]
        while i < valid_rows.size
          if i+1 == valid_rows.size || (valid_rows[i+1] - valid_rows[i] != 1)
            color_rows(ss, start_row, valid_rows[i], 0, header.size, 0.8509804, 0.91764706, 0.827451, 1.0, auth)
            start_row = valid_rows[i+1]
          end
          i += 1
        end

        i = 0
        start_row = error_rows[i]
        while i < error_rows.size
          if i+1 == error_rows.size || (error_rows[i+1] - error_rows[i] != 1)
            color_rows(ss, start_row, error_rows[i], 0, header.size, 0.9019608, 0.72156864, 0.6862745, 1.0, auth)
            start_row = error_rows[i+1]
          end
          i += 1
        end
      rescue => ex
        Rails.logger.error(ex)
        flash[:notice] = ex.message
      end
    end

    respond_to do |format|
      format.html { redirect_to url_for([get_namespace, @catalog]) }
    end
  end

private
  def catalog_params
    params.require(:catalog).permit(:name, :source, :active)
  end
end
