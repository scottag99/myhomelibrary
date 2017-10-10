class CatalogPageController < CmsController
  before_action :find_books

  def find_books
    @active_books = CatalogEntry.joins(:catalog).includes(:book).where('catalogs.active = ? and disabled = ?', true, false).all
  end
end
