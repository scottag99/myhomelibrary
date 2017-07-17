class HomeController < ApplicationController
  before_action :find_organization, only: [:search, :wishlists]
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
      @schoolname = "None"
      @Campaign = "General"
      @reader_name = ""
      @wishListID = ""
      @slug = ""
      @campaign_id = ""
      if !params[:campaign_id].nil? && campaign = Campaign.find(params[:campaign_id])
        @Campaign = campaign.name
        @schoolname = campaign.organization.name
        @slug = campaign.organization.slug
        @campaign_id = campaign.id
      end
      if !params[:organization_id].nil? && org = Organization.find(params[:organization_id])
        @schoolname = org.name
        @slug = org.slug
      end
    else
      school = {}
      campaign = {}
      reader = {}
      slug = {}

      @wishlists = Wishlist.joins([{:campaign => :organization}]).where("wishlists.id in (?)", params[:id_list].split(",").map(&:to_i)).all
      @wishlists.each{|w|
        school[w.campaign.organization.name] = true
        campaign[w.campaign.name] = true
        reader[w.reader_name] = true
        slug[w.campaign.organization.slug] = true
      }
      @schoolname = school.keys.join(",")
      @donationLevel = 30.0*@wishlists.count #TODO: Make the amount configurable
      @Campaign = campaign.keys.join(",")
      @reader_name = reader.keys.join(",")
      @wishListID = params[:id_list]
      @slug = slug.keys.join("") if slug.count == 1
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
    if @wishlists.count > 0
      amt = params[:amount].to_d/@wishlists.count unless params[:amount].nil? || @wishlists.count == 0
      @wishlists.each do |w|
        @donation = w.donations.create!({:confirmation_code => params[:confirmation_code], :amount => amt})
      end
    elsif campaign = Campaign.find(params[:campaign_id])
      @donation = campaign.donations.create!({:confirmation_code => params[:confirmation_code], :amount => params[:amount]})
    end

    session[:wishlist_cart] = nil

    respond_to do |format|
      format.html { render "index" }
      format.json { render json: @donation }
    end
  end

private

  def find_organization
    unless params[:slug].nil?
      @organization = Organization.find_by_slug(params[:slug])
    end

    #if !params[:term].nil? && @organization.nil?
    #  @organization = Organization.find_by_name(params[:term])
    #end
  end

  def find_wishlists
    term = params[:term]
    ids = (session[:wishlist_cart] || "").split(",").map(&:to_i)
    if term.to_s.size < 2
      if @organization.nil?
        where = "(deadline > ? and ready_for_donations = ?)"
        where_args = [Date.today, true]
      else
        where = "(deadline > ? and ready_for_donations = ? and organizations.id = ?)"
        where_args = [Date.today, true, @organization.id]
      end
      @wishlists = Wishlist.has_books.includes([{campaign: :organization}, {wishlist_entries: {catalog_entry: :book}}]).where("wishlists.id in (?)", ids)
      @wishlists = @wishlists + Wishlist.has_books.joins({campaign: :organization}).includes([{campaign: :organization}, {wishlist_entries: {catalog_entry: :book}}]).where(where, *where_args).order('random()').limit(20)
    else
      term = "%#{term.downcase}%"
      if @organization.nil?
        where = "wishlists.id in (?) or (deadline > ? and ready_for_donations = ? and (lower(reader_name) like ? or lower(teacher) like ? or lower(organizations.name) like ?))"
        where_args = [ids, Date.today, true, term, term, term]
      else
        where = "wishlists.id in (?) or (deadline > ? and ready_for_donations = ? and organizations.id = ? and (lower(reader_name) like ? or lower(teacher) like ?))"
        where_args = [ids, Date.today, true, @organization.id, term, term]
      end
      @wishlists = Wishlist.has_books.joins({campaign: :organization}).includes([{campaign: :organization}, {wishlist_entries: {catalog_entry: :book}}]).where(where, *where_args).order(:reader_name).all
    end
    wishlist_ids = @wishlists.collect{|w| w.id}
    @wishlist_prices = WishlistEntry.group("wishlist_id").where("wishlist_id in (?)", wishlist_ids).sum(:price)
    @donations = Donation.group("wishlist_id").where("wishlist_id in (?)", wishlist_ids).sum(:amount)
  end

  def find_content
    @content = Content.where(action_name: action_name).all.map{|c| [c.name, c.content]}.to_h
  end

end
