module CommonWishlistActions
  extend ActiveSupport::Concern

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
      format.json { render json: @wishlist }
    end
  end

  def manage
    @wishlist = current_campaign.wishlists.find(params[:id])
    @add_url = get_add_url(@wishlist)
    @delete_url = get_delete_url(@wishlist)
    @back_url = get_campaign_url
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

  def edit
    @wishlist = current_campaign.wishlists.find(params[:id])

    respond_to do |format|
      format.html { render 'common/form', locals: {form_title: 'Edit Wishlist', model: 'wishlists'} }
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

  def destroy
    current_campaign.wishlists.destroy(params[:id])
    respond_to do |format|
      format.html { redirect_to get_campaign_url }
      format.json { render json: current_campaign.wishlists.all}
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
private
  def wishlist_params
    params.require(:wishlist).permit(:reader_name, :reader_age, :reader_gender, :teacher, :grade, :grl, :external_id)
  end
end
