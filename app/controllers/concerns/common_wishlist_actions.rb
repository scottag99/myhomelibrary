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

  def edit
    @wishlist = current_campaign.wishlists.find(params[:id])
    @add_url = get_add_url(@wishlist)
    @delete_url = get_delete_url(@wishlist)
    @back_url = get_campaign_url

    respond_to do |format|
      format.html
      format.json { render json: @wishlist }
    end
  end

  def new
    @wishlist = current_campaign.wishlists.new
    respond_to do |format|
      format.html
      format.json { render json: @wishlist }
    end
  end

  def destroy
    current_campaign.wishlists.delete(params[:id])
    respond_to do |format|
      format.html { redirect_to get_campaign_url }
      format.json { render json: current_campaign.wishlists.all}
    end
  end
private
  def wishlist_params
    params.require(:wishlist).permit(:reader_name, :reader_age, :reader_gender, :teacher)
  end
end
