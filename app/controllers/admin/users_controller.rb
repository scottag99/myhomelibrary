require "auth0"

class Admin::UsersController < Admin::BaseController
  def index
    auth0 = get_auth0_client
    @users = auth0.get_users
  end
  private
  def get_auth0_client
    return Auth0Client.new(
      :client_id => Rails.application.secrets.auth0_client_id,
      :token => Rails.application.secrets.auth0_api_token,
      :domain => "myhomelibrary.auth0.com",
      :protocols => 'v2',
      :api_version => 2
    )
  end

end
