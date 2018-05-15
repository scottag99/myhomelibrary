Rails.application.routes.draw do

  get "/auth/auth0/callback" => "auth0#callback"
  get "/auth/failure" => "auth0#failure"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: redirect('/home')
  get 'home/library'
  get 'donate', to: 'home#donate'
  get 'give', to: 'home#give'
  get 'bookdrive', to: 'home#bookdrive'
  get 'search/:slug', to: redirect('/search?slug=%{slug}'), as: 'search'
  get 'wishlists', to: 'home#wishlists'
  post 'success', to: 'home#success'

  get  'login', to: 'home#login'
  get 'logout', to: 'home#logout'

  namespace :admin do
    root to: 'home#index'
    get 'admin/organizations', to: 'admin/organizations#index', as: 'admin_organizations_path'
    resources :users do
      member do
        put 'toggle_admin'
      end
    end
    resources :books
    resources :catalogs do
      member do
        get 'export'
        put 'active'
        post 'upload'
      end
      resources :catalog_entries
    end
    resources :contents
    resources :organizations do
      member do
        put 'included'
      end
      resources :partners do
        member do
          put 'toggle_coordinator'
        end
      end
      resources :campaigns do
        member do
          get 'order_sheet'
          get 'pick_list'
          get 'export'
          get 'book_count'
          get 'exportroster'
          get 'readers'
          put 'donations'
          put 'wishlists'
        end
        resources :wishlists do
          member do
            get 'manage'
            put 'toggle_delivered'
          end
          collection do
            get  'edit_multiple'
            put  'update_multiple'
            get  'edit_upload'
            post 'upload'
            get  'download'
          end
          resources :wishlist_entries
        end
      end
    end
  end

  namespace :partner, :path => 'volunteer' do
    root to: 'home#index'
    resources :organizations do
      resources :partners
      resources :campaigns do
        member do
          get 'order_sheet'
          get 'pick_list'
          get 'export'
          get 'book_count'
          get 'exportroster'
          get 'readers'
          put 'donations'
          put 'wishlists'
        end
        resources :wishlists do
          member do
            get 'manage'
            put 'toggle_delivered'
          end
          collection do
            get  'edit_multiple'
            put  'update_multiple'
            get  'edit_upload'
            post 'upload'
            get  'download'
          end
          resources :wishlist_entries
        end
      end
    end
  end

  # Default Scrivito routes. Adapt them to change the routing of CMS objects.
  # See the documentation of 'scrivito_route' for a detailed description.
  scrivito_route '/', using: 'homepage'
  scrivito_route '(/)(*slug-):id', using: 'slug_id'
  scrivito_route '/(*permalink)/(:slug)', using: 'permalink', format: false


end
