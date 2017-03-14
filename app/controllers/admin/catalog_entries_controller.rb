class Admin::CatalogEntriesController < Admin::BaseController
  before_action :find_catalog
  def index
    @catalog_entries = @catalog.catalog_entries
    respond_to do |format|
      format.html
      format.json { render json: @catalog_entries }
    end
  end

  def show
    @catalog_entry = @catalog.catalog_entries.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: @catalog_entry }
    end
  end

  def edit
    @catalog_entry = @catalog.catalog_entries.includes(:book).find(params[:id])
    @related_entries = @catalog.catalog_entries.includes(:book).where("catalog_entries.id != ?", @catalog_entry).order("books.title")

    respond_to do |format|
      format.html
      format.js
      format.json { render json: @book }
    end
  end

  def update
    @catalog_entry = @catalog.catalog_entries.find(params[:id])
    @catalog_entry.update!(catalog_entry_params)
    respond_to do |format|
      format.html { render "show" }
      format.js   { render "show" }
      format.json { render json: @catalog_entry }
    end
  end

  def new
    @related_entries = @catalog.catalog_entries
    @catalog_entry = @catalog.catalog_entries.new
    @catalog_entry.book = Book.new

    respond_to do |format|
      format.html
      format.js
      format.json { render json: @catalog_entry }
    end
  end

  def create
    attrs = catalog_entry_params
    book = Book.where(isbn: attrs[:book_attributes][:isbn])
    unless book.empty?
      attrs[:book_id] = book[0].id
      attrs.delete(:book_attributes)
    end
    @catalog_entry = @catalog.catalog_entries.new(attrs)
    if @catalog_entry.save
      respond_to do |format|
        format.html { render "show" }
        format.js
        format.json { render json: @catalog_entry }
      end
    else
      respond_to do |format|
        format.html { render "new" }
        format.js { render "new" }
        format.json { render json: @catalog_entry }
      end
    end
  end

  def destroy
    @catalog_entry_id = params[:id]
    @catalog.catalog_entries.destroy(params[:id])
    respond_to do |format|
      format.html { render "index" }
      format.js
      format.json { render json: @catalog.catalog_entries.all}
    end
  end
private
  def find_catalog
    @catalog = Catalog.find(params[:catalog_id])
  end

  def catalog_entry_params
    params.require(:catalog_entry).permit(:book_id, :price, :disabled, :related_entry_id, book_attributes: [:id, :title, :author, :description, :year, :isbn, :cover_image_url, :level, :ar_level, :ar_points, :grl, :dra, :is_bilingual])
  end
end
