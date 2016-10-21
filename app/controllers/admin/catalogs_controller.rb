class Admin::CatalogsController < Admin::BaseController
  def index
    @catalogs = Catalog.all
    respond_to do |format|
      format.html
      format.json { render json: @catalogs }
    end
  end
end
