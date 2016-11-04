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
    redirect_to root_url
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
    @wishlists = Wishlist.joins(:campaign, :wishlist_entries).where("deadline > ? and ready_for_donations = ?", Date.today, true).uniq.all
  end

  def success
    wishlist = Wishlist.find(params[:wishlist_id])
    @donation = wishlist.donations.create!({:confirmation_code => params[:confirmation_code], :amount => params[:amount]})

    respond_to do |format|
      format.html { render "index" }
      format.json { render json: @donation }
    end
  end
end
