source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.3'
gem 'activerecord-session_store'

# Use Puma as the app server
gem 'puma', '~> 3.12'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'omniauth-auth0', '~> 2.2.0'
gem 'omniauth-rails_csrf_protection', '~> 0.1'

# https://github.com/auth0/ruby-auth0 For API access
gem 'auth0'

gem 'google-api-client'

# Scrivito
gem "scrivito", "~> 1.9"
gem 'scrivito_two_column_widget'
gem 'scrivito_three_column_widget'
gem 'scrivito_linklist_widget'
gem 'scrivito_elastic_slider_widget'
gem 'scrivito_section_widgets', '~> 1.1'
gem 'scrivito_accordion_widget'
gem 'scrivito_video_widget'
gem 'scrivito_content_box_widget'
gem 'scrivito_column_widget', '~> 0.1.2'
# gem 'scrivito_quote_widget', '~> 0.4.4'
gem 'scrivito_text_image_widget', '~> 0.1.0'
gem 'scrivito_picture_widget', '~> 0.1.1'

gem 'roo', "~> 2.7.0"

gem 'bootstrap-sass', '~> 3.3.6'
gem 'momentjs-rails', '>= 2.9.0'
gem 'bootstrap3-datetimepicker-rails', '~> 4.17.42'

group :development, :production do
  gem 'pg', '~> 0.21'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'dotenv-rails'
end

group :production do
  gem 'rails_12factor'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'seed_dump'
end

group :test do
  gem 'sqlite3'
end

ruby "2.6.5"
