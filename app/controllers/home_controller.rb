class HomeController < ApplicationController
  before_action :find_wishlists, only: [:search, :wishlists]
  before_action :find_content, only: [:index, :search, :wishlists]

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
    redirect_to "https://#{Rails.application.config.auth0_endpoint}/v2/logout?returnTo=#{params['returnTo']}&client_id=#{params['client_id']}"
  end

  def library
  end

  def donate
    if params[:id_list].nil?
      @wishlists = []
      @donationLevel = 30.0
      @Campaign = "General"
      @schoolname = "None"
      @reader_name = ""
      @wishListID = ""
    else
      school = {}
      campaign = {}
      reader = {}

      @wishlists = Wishlist.joins([{:campaign => :organization}]).where("wishlists.id in (?)", params[:id_list].split(",").map(&:to_i)).all
      @wishlists.each{|w|
        school[w.campaign.organization.name] = true
        campaign[w.campaign.name] = true
        reader[w.reader_name] = true
      }
      @schoolname = school.keys.join(",")
      @donationLevel = 30.0*@wishlists.count #TODO: Make the amount configurable
      @Campaign = campaign.keys.join(",")
      @reader_name = reader.keys.join(",")
      @wishListID = params[:id_list]
      session[:wishlist_cart] = params[:id_list]
    end
  end

  def search
  end

  def wishlists
    respond_to do |format|
      format.js {}
    end
  end

  def success
    @wishlists = Wishlist.joins([{:campaign => :organization}]).where("wishlists.id in (?)", params[:id_list].split(",").map(&:to_i)).all
    @wishlists.each do |w|
      @donation = w.donations.create!({:confirmation_code => params[:confirmation_code], :amount => params[:amount]})
    end

    session[:wishlist_cart] = nil

    respond_to do |format|
      format.html { render "index" }
      format.json { render json: @donation }
    end
  end

private

  def find_wishlists
    term = params[:term]
    ids = (session[:wishlist_cart] || "").split(",").map(&:to_i)
    #By joining wishlist_entries, we get only wishlists with books added.
    if term.to_s.size < 2
      @wishlists = Wishlist.joins([{:campaign => :organization},"INNER JOIN (select count(*), wishlist_id from wishlist_entries group by wishlist_id having count(*) > 0) c on c.wishlist_id = wishlists.id"]).where("wishlist_id in (?)", ids)
      @wishlists = @wishlists + Wishlist.joins([{:campaign => :organization},"INNER JOIN (select count(*), wishlist_id from wishlist_entries group by wishlist_id having count(*) > 0) c on c.wishlist_id = wishlists.id"]).where("(deadline > ? and ready_for_donations = ?)", Date.today, true).order('random()').limit(20)
    else
      term = "%#{term.downcase}%"
      @wishlists = Wishlist.joins([{:campaign => :organization}, :wishlist_entries]).where("wishlist_id in (?) or (deadline > ? and ready_for_donations = ? and (lower(reader_name) like ? or lower(teacher) like ? or lower(organizations.name) like ?))", ids, Date.today, true, term, term, term).distinct.order(:reader_name).all
    end
  end

  def find_content
    @content = Content.where(action_name: action_name).all.map{|c| [c.name, c.content]}.to_h
  end

end
