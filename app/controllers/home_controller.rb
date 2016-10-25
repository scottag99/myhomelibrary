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
    @wishListID = params[:wishListID]
    @donationLevel = params[:donationLevel]
    @Semester = params[:Semester]

  end

  def search

  end
end
