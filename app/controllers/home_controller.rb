class HomeController < ApplicationController
  def index
  end

  def login
    respond_to do |format|
      format.html
      format.json { render json: {:error => "No auth token sent"} }
    end
  end

  def logout
    reset_session
    redirect_to "/"
  end

  def library

  end

  def donate

    @schoolname = params[:schoolname]
    @wishListID = params[:wishlist_id]
    @donationLevel = params[:amount]
    @Semester = params[:campaign_name]

  end

  def search
    #Load all current wishlists with at least one book
    @wishlists = Wishlist.joins(:campaign, :wishlist_entries).where("deadline > ?", [Date.today]).uniq.all
  end
end
