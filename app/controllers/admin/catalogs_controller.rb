require 'nokogiri'
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
    uploaded_io = params[:catalog][:upload]
    doc = File.open(uploaded_io.path) { |f| Nokogiri::XML(f) }

    doc.xpath('//product').each do |elem|
      b = Book.create({
        :title => elem.xpath('./name').first.text,
        :author => elem.xpath('./author').first.text,
        :description => elem.xpath('./description').first.text,
        :isbn => elem.xpath('./isbn').first.text.sub('<b>ISBN:</b> ', ''),
        :level => elem.xpath('./grade').first.text.sub('<b>Grade:</b> ', ''),
        :cover_image_url => elem.xpath('./coverimage/image').attr('href')
      })
    end

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
