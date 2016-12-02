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

  def edit
    @catalog = Catalog.find(params[:id])
    respond_to do |format|
      format.html
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
    uploaded_io = params[:catalog][:upload]
    doc = File.open(uploaded_io.path) { |f| Nokogiri::XML(f) }

    doc.xpath('//product').each do |elem|
      isbn = elem.xpath('./isbn').first.text

      b = Book.where(isbn: isbn).first_or_initialize
      b.title = elem.xpath('./name').first.text
      b.author = elem.xpath('./author').first.text
      b.description = elem.xpath('./description').first.inner_html
      b.isbn = isbn
      b.level = elem.xpath('./grade').first.text
      b.cover_image_url = elem.xpath('./coverimage/image').attr('href')
      b.ar_points = elem.at_xpath('./ar_points').nil? ? nil : elem.xpath('./ar_points').first.text
      b.ar_level = elem.at_xpath('./ar_level').nil? ? nil : elem.xpath('./ar_level').first.text
      b.save

      entry = @catalog.catalog_entries.new
      entry.book = b
      entry.price = elem.xpath('./cost').first.inner_html.sub('$', '')
      entry.save
    end

    respond_to do |format|
      format.html { render "show" }
      format.json { render json: @catalog }
    end
  end

  def destroy
    Catalog.destroy(params[:id])
    @catalogs = Catalog.all
    respond_to do |format|
      format.html { render "index" }
      format.json { render json: @catalogs}
    end
  end

private
  def catalog_params
    params.require(:catalog).permit(:name, :source, :active)
  end
end
