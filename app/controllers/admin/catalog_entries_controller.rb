class Admin::CatalogEntriesController < Admin::BaseController
  def index
    @catalog_entries = current_catalog.catalog_entries
    respond_to do |format|
      format.html
      format.json { render json: @catalog_entries }
    end
  end

  def show
    @catalog_entry = current_catalog.catalog_entries.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: @catalog_entry }
    end
  end

  def update
    @catalog_entry = current_catalog.catalog_entries.find(params[:id])
    @catalog_entry.update!(catalog_entry_params)
    respond_to do |format|
      format.html { render "show" }
      format.json { render json: @catalog_entry }
    end
  end

  def new
    @catalog_entry = current_catalog.catalog_entries.new
    respond_to do |format|
      format.html
      format.json { render json: @catalog_entry }
    end
  end

  def create
    @catalog_entry = current_catalog.catalog_entries.create!(catalog_entry_params)
    respond_to do |format|
      format.html { render "show" }
      format.json { render json: @catalog_entry }
    end
  end

  def destroy
    current_catalog.catalog_entries.delete(params[:id])
    respond_to do |format|
      format.html { render "index" }
      format.json { render json: current_catalog.catalog_entries.all}
    end
  end
private
  def current_catalog
    Catalog.find(params[:catalog_id])
  end

  def catalog_entry_params
    params.require(:catalog_entry).permit(:book_id, :price)
  end
end
