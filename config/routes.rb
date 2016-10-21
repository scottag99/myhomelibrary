Rails.application.routes.draw do
  get "/auth/auth0/callback" => "auth0#callback"
  get "/auth/failure" => "auth0#failure"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'home/index'
  root 'home#index'
  get  'login', to: 'home#login'
  get 'logout', to: 'home#logout'

  namespace :admin do
    root 'home#index'
    resources :users
  end

  namespace :partner do
    root 'home#index'
  end
end
