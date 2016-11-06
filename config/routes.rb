Rails.application.routes.draw do

  get "/auth/auth0/callback" => "auth0#callback"
  get "/auth/failure" => "auth0#failure"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'home#index'
  get 'home/library'
  get 'donate', to: 'home#donate'
  get 'search', to: 'home#search'
  get 'wishlists', to: 'home#wishlists'
  post 'success', to: 'home#success'

  get  'login', to: 'home#login'
  get 'logout', to: 'home#logout'

  namespace :admin do
    root to: 'home#index'
    resources :users
    resources :books
    resources :catalogs do
      resources :catalog_entries
    end
    resources :organizations do
      resources :campaigns do
        member do
          get 'order_sheet'
          get 'pick_list'
        end
        resources :wishlists do
          resources :wishlist_entries
        end
      end
    end
  end

  namespace :partner do
    root to: 'home#index'
    resources :organizations do
      resources :campaigns do
        resources :wishlists do
          resources :wishlist_entries
        end
      end
    end
  end
end
