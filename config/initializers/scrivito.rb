Scrivito.configure do |config|
  #
  # Uncomment following lines in order to explicitly set the tenant and the API key.
  # If not explicitly set, the tenant and the API key are obtained from the environment variables
  # SCRIVITO_TENANT and SCRIVITO_API_KEY.
  #
  config.tenant = ENV["SCRIVITO_TENANT"]
  config.api_key = ENV["SCRIVITO_API_KEY"]
  #

  # Disable the default routes to allow route configuration
  config.inject_preset_routes = false

  config.editing_auth do |env|
      user_data = env['rack.session'][:userinfo]

    unless user_data.blank?

      if user_data['extra'] && user_data['extra']['raw_info']
        role = user_data['extra']['raw_info']['role']
      end
      if user_data && !role.blank? && role == 'admin'

        # Note: avoid requests to the user back end in the `editing_auth` callback
        # as it is evaluated on every request to your application!

        Scrivito::User.define(user_data['uid']) do |user_definition|
          user_definition.description { "#{user_data['info']['name']}" }
          # Extend the user definition here
        end
      end
    end
  end
    config.find_user do |user_id|
      # MyUserConversion.to_scrivito_user(MyUser.find(user_id))
    end

end
