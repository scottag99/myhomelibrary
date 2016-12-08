require "auth0"

class Admin::UsersController < Admin::BaseController
  def index
    auth0 = get_auth0_client
    @users = auth0.get_users
  end

  def toggle_admin
    auth0 = get_auth0_client
    user = auth0.user(params[:id])
    app_meta = user['app_metadata'] || {'role' => '' }
    app_meta['role'] = app_meta['role'].empty? ? 'admin' : ''
    auth0.patch_user(params[:id], {'app_metadata' => app_meta})
    flash[:success] = 'User updated. This change takes a few seconds to take effect. Refresh this page to see change.'
    redirect_to admin_users_url
  end

  def destroy
    auth0 = get_auth0_client
    auth0.delete_user(params[:id])
    flash[:success] = 'User deleted. This change takes a few seconds to take effect. Refresh this page to see change.'
    redirect_to admin_users_url
  end

  private
  def get_auth0_client
    return Auth0Client.new(
      :client_id => Rails.application.secrets.auth0_client_id,
      :token => Rails.application.secrets.auth0_api_token,
      :domain => Rails.application.config.auth0_endpoint,
      :protocols => 'v2',
      :api_version => 2
    )
  end

end
