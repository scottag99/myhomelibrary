class Admin::PacksController < Admin::BaseController
  before_action :find_catalog
  def index
    @packs = @catalog.packs
    respond_to do |format|
      format.html
      format.json { render json: @packs }
    end
  end

  def show
    @pack = @catalog.packs.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: @pack }
    end
  end

  def edit
    @pack = @catalog.packs.find(params[:id])

    respond_to do |format|
      format.html
      format.js
      format.json { render json: @pack }
    end
  end

  def update
    @pack = @catalog.packs.find(params[:id])
    @pack.update!(pack_params)
    respond_to do |format|
      format.html { render "show" }
      format.js   { render "show" }
      format.json { render json: @pack }
    end
  end

  def new
    @pack = @catalog.packs.new

    respond_to do |format|
      format.html
      format.js
      format.json { render json: @pack }
    end
  end

  def create
    @pack = @catalog.packs.new(pack_params)
    if @pack.save
      respond_to do |format|
        format.html { render "show" }
        format.js
        format.json { render json: @pack }
      end
    else
      respond_to do |format|
        format.html { render "new" }
        format.js { render "new" }
        format.json { render json: @pack }
      end
    end
  end

  def destroy
    @pack_id = params[:id]
    @catalog.packs.destroy(params[:id])
    respond_to do |format|
      format.html { render "index" }
      format.js
      format.json { render json: @catalog.packs.all}
    end
  end

  def generate_packs
    warehouse_packs = [['BbPkEn', 'Black'],['BbPkBi', 'Navy'],['BbKEn', 'Silver'],['BbKBi', 'Brown']]
    scholastic_packs = [['1ePkEn','Pink'],['1ePkBi','Blue'],['1eK1En','Orange'],['1eK1Bi','Purple'],
      ['1e23En','Yellow'],['1e23Bi','Green'],['1e45En','Red'],['2ePkEn','Pink'],
      ['2ePkBi','Blue'],['2eK1En','Orange'],['2eK1Bi','Purple'],['2e23En','Yellow'],
      ['2e23Bi','Green'],['2e45En','Red'],['3ePkEn','Pink'],['3ePkBi','Blue'],
      ['3eK1En','Orange'],['3eK1Bi','Purple'],['3e23En','Yellow'],['3e23Bi','Green'],
      ['3e45En','Red'],['4ePkEn','Pink'],['4ePkBi','Blue'],['4eK1En','Orange'],
      ['4eK1Bi','Purple'],['4e23En','Yellow'],['4e23Bi','Green'],['4e45En','Red']]
    packs = params[:source] == 'warehouse' ? warehouse_packs : scholastic_packs
    packs.each do |pack|
      @catalog.packs.create(ezid: pack[0], pack_type: pack[1], price: 5.00)
    end

    respond_to do |format|
      format.html { redirect_to admin_catalog_url(@catalog) }
    end
  end
private
  def find_catalog
    @catalog = Catalog.find(params[:catalog_id])
  end

  def pack_params
    params.require(:pack).permit(:ezid, :pack_type, :description, :price)
  end
end
