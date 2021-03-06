class ApplicationController < ActionController::Base
  protect_from_forgery prepend: true, with: :exception
  skip_before_action :verify_authenticity_token, if: :json_request?

  def json_request?
    request.format.json?
  end

  def get_namespace
    controller_path.split('/').first
  end

end
