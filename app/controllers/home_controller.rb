class HomeController < ApplicationController
  include CommonSearchActions
  before_action :find_organization, only: [:search, :wishlists]
  before_action :find_wishlists, only: [:search, :wishlists]
  before_action :find_content, only: [:index, :search, :wishlists]

  def index
  end

  def give
  end

  def bookdrive
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
    addl_donation = params[:addl_donation].nil? ? 0.0 : params[:addl_donation].to_d
    addl_donation_slug = params[:addl_donation_slug].nil? ? 0.0 : params[:addl_donation_slug].to_d
    @is_classroom_sponsored = params[:classroom] == 'true'
    if params[:id_list].nil?
      @wishlists = []
      @donationLevel = addl_donation + addl_donation_slug
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
        reader[w.public_name] = true
        slug[w.campaign.organization.slug] = true
      }
      @schoolname = school.keys.join(",")
      @donationLevel = addl_donation + addl_donation_slug + (30.0*@wishlists.count) #TODO: Make the amount configurable
      @Campaign = campaign.keys.join(",")
      @reader_name = reader.keys.join(",")
      @wishListID = params[:id_list]
      @slug = slug.keys.join("") if slug.count == 1
      session[:wishlist_cart] = params[:id_list]
    end
  end

  def sponsor_classroom
    @wishlist_ids = Wishlist.joins('LEFT JOIN donations on donations.wishlist_id = wishlists.id').where("teacher = ? and wishlists.campaign_id = ? and donations.id is NULL", params[:teacher], params[:campaign_id]).pluck(:id)
  end

  def search
  end

  def wishlists
    @is_classroom_sponsored = false
    respond_to do |format|
      format.js {}
    end
  end

  def in_kind
    @donation = Donation.find_by_confirmation_code(params[:code])
  end

  def success
    @wishlists = Wishlist.joins([{:campaign => :organization}]).where("wishlists.id in (?)", params[:id_list].split(",").map(&:to_i)).all
    if @wishlists.count > 0
      amt = params[:amount].to_d/@wishlists.count unless params[:amount].nil? || @wishlists.count == 0
      @wishlists.each do |w|
        @donation = w.donations.create!({:confirmation_code => params[:confirmation_code], 
          :amount => amt, 
          :is_classroom_sponsorship => params[:is_classroom_sponsored],
          :is_in_kind => params[:is_in_kind],
          :in_name_of => params[:in_name_of],
          :in_kind_message => params[:in_kind_message]})
      end
    elsif campaign = Campaign.find(params[:campaign_id])
      @donation = campaign.donations.create!({:confirmation_code => params[:confirmation_code], 
        :amount => params[:amount],
        :is_in_kind => params[:is_in_kind],
        :in_name_of => params[:in_name_of],
        :in_kind_message => params[:in_kind_message]})
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

  def find_content
    @content = Content.where(action_name: action_name).all.map{|c| [c.name, c.content]}.to_h
  end

end
