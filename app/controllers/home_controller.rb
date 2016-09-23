class HomeController < ApplicationController
  def index
  end

  def login
  end

  def logout
    reset_session
    redirect_to "/"
  end
end
