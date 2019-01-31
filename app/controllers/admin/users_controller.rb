require "auth0"
require "uri"
require "net/http"

class Admin::UsersController < Admin::BaseController
  before_action :set_pagination

  def index
    auth0 = get_auth0_client
    q = {
      page: @pagination[:page] - 1, # auth0 is zero-index based for pages
      per_page: @pagination[:per_page],
      sort: 'name:1',
      include_totals: true
    }
    r = auth0.users q
    @users = r["users"]
    @is_last_page = r["start"] + r["length"] == r["total"]
  end

  def toggle_admin
    auth0 = get_auth0_client
    user = auth0.user(params[:id])
    app_meta = user['app_metadata'] || {'role' => '' }
    app_meta['role'] = app_meta['role'].empty? ? 'admin' : ''
    auth0.patch_user(params[:id], {'app_metadata' => app_meta})
    flash[:success] = 'User updated. This change takes a few seconds to take effect. Refresh this page to see change.'
    redirect_to admin_users_url(@pagination)
  end

  def destroy
    auth0 = get_auth0_client
    auth0.delete_user(params[:id])
    flash[:success] = 'User deleted. This change takes a few seconds to take effect. Refresh this page to see change.'
    redirect_to admin_users_url(@pagination)
  end

private

  def get_auth0_client
    return Auth0Client.new(
      :client_id => Rails.application.secrets.auth0_client_id,
      :token => get_token,
      :domain => Rails.application.config.auth0_endpoint,
      :protocols => 'v2',
      :api_version => 2
    )
  end

  def get_token
    Rails.cache.fetch('auth0_token', expires_in: 12.hours) do
      url = URI("https://#{Rails.application.config.auth0_endpoint}/oauth/token")
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Post.new(url)
      request["content-type"] = 'application/json'
      request.body = "{\"client_id\":\"#{Rails.application.secrets.auth0_client_id}\",\"client_secret\":\"#{Rails.application.secrets.auth0_client_secret}\",\"audience\":\"https://#{Rails.application.config.auth0_endpoint}/api/v2/\",\"grant_type\":\"client_credentials\"}"

      response = http.request(request)
      Rails.logger.info "Auth0 token request response code: #{response.code}"
      if response.code != '200'
        raise "Failed to retrieve token from Auth0"
      end
      body = JSON.parse(response.read_body)
      token = body["access_token"]
      return token
    end
  end

  def set_pagination
    @pagination = {
      page: (params[:page] || 1).to_i,
      per_page: (params[:per_page] || 50).to_i.abs # force positive value
    }
    @pagination[:page] = 1 if @pagination[:page] < 1
  end
end
