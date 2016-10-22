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

  def partner
    @campaign = Campaign.all
    respond_to do |format|
      format.html 
      format.json { render json: @campaign }
    end
  end
end
