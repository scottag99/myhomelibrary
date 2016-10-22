Rails.application.routes.draw do

  get "/auth/auth0/callback" => "auth0#callback"
  get "/auth/failure" => "auth0#failure"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'home/index'
  root 'home#index'
  get 'home/library'
  get 'home/search'
  get  'login', to: 'home#login'
  get 'logout', to: 'home#logout'

  namespace :admin do
    root 'home#index'
    resources :users
    resources :books
    resources :catalogs do
      resources :catalog_entries
    end
    resources :organizations do
      resources :campaigns do
        resources :wishlists do
          resources :wishlist_entries
        end
      end
    end
  end

  namespace :partner do
    root 'home#index'
    resources :organizations do
      resources :campaigns do
        resources :wishlists do
          resources :wishlist_entries
        end
      end
    end
  end
end
