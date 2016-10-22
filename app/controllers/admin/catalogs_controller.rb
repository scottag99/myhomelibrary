class Admin::CatalogsController < Admin::BaseController
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
      format.html
      format.json { render json: @catalog }
    end
  end

  def update
    @catalog = Catalog.find(params[:id])
    @catalog.update!(catalog_params)
    respond_to do |format|
      format.html { render "show" }
      format.json { render json: @catalog }
    end
  end

  def create
    @catalog = Catalog.create!(catalog_params)
    respond_to do |format|
      format.html { render "show" }
      format.json { render json: @catalog }
    end
  end

  def destroy
    Catalog.delete(params[:id])
    respond_to do |format|
      format.html { render "index" }
      format.json { render json: Catalog.all}
    end
  end
private
  def catalog_params
    params.require(:catalog).permit(:name, :source, :active)
  end
end
