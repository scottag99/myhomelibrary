class HomeController < ApplicationController
  before_action :find_wishlists, only: [:search, :wishlists]

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
    @reader_name = params[:reader_name]
  end

  def search
  end

  def wishlists
    respond_to do |format|
      format.js {}
    end
  end

  def success
    wishlist = Wishlist.find(params[:wishlist_id])
    @donation = wishlist.donations.create!({:confirmation_code => params[:confirmation_code], :amount => params[:amount]})

    respond_to do |format|
      format.html { render "index" }
      format.json { render json: @donation }
    end
  end

private

  def find_wishlists
    term = params[:term]
    #By joining wishlist_entries, we get only wishlists with books added.
    if term.to_s.size < 2
      @wishlists = Wishlist.joins([{:campaign => :organization},"INNER JOIN (select count(*), wishlist_id from wishlist_entries group by wishlist_id having count(*) > 0) c on c.wishlist_id = wishlists.id"]).where("deadline > ? and ready_for_donations = ?", Date.today, true).order('random()').limit(20)
    else
      term = "%#{term}%"
      # ILIKE is a postgres extension so this fails in local dev environments
      @wishlists = Wishlist.joins([{:campaign => :organization}, :wishlist_entries]).where("deadline > ? and ready_for_donations = ? and (reader_name ilike ? or teacher ilike ? or organizations.name ilike ?)", Date.today, true, term, term, term).distinct.order(:reader_name).all
    end
  end
end
