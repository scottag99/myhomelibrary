Rails.application.routes.draw do

  get "/auth/auth0/callback" => "auth0#callback"
  get "/auth/failure" => "auth0#failure"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: redirect('/home')
  get 'home/library'
  get 'donate', to: 'home#donate'
  get 'donation/:code', to: 'home#in_kind'
  post 'sponsor_classroom', to: 'home#sponsor_classroom'
  post 'sponsor_grade', to: 'home#sponsor_grade'
  get 'give', to: 'home#give'
  get 'bookdrive', to: redirect('https://www.bushhoustonliteracy.org/book-drive', status: 302)
  get 'search/:slug', to: redirect('/search?slug=%{slug}'), as: 'old_search'
  get 'wishlists', to: 'home#wishlists'
  post 'success', to: 'home#success'

  get  'login', to: 'home#login'
  get 'logout', to: 'home#logout'

  namespace :admin do
    root to: 'home#index'
    get 'reports', to: 'home#reports', as: 'reports_path'
    resources :surveys do
      member do
        put 'is_disabled'
        post 'reorder'
      end
      resources :survey_questions
    end
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
          get 'new_grade_sponsorship'
          post 'create_grade_sponsorship'
          get 'new_external_donation'
          post 'create_external_donation'
          put 'donations'
          put 'wishlists'
          get 'export_survey'
        end
        resources :campaign_survey_configs
        resources :wishlists do
          member do
            get 'manage'
            put 'toggle_delivered'
            get 'take_survey'
            post 'save_response'
            get 'survey_complete'
          end
          collection do
            get  'edit_multiple'
            put  'update_multiple'
            delete 'destroy_multiple'
            get  'edit_upload'
            post 'upload'
            get  'download'
          end
          resources :wishlist_entries
          resources :appreciation_notes
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
            get 'take_survey'
            post 'save_response'
            get 'survey_complete'
          end
          collection do
            get  'edit_multiple'
            put  'update_multiple'
            get  'edit_upload'
            post 'upload'
            get  'download'
          end
          resources :wishlist_entries
          resources :appreciation_notes
        end
      end
    end
  end

  # Default Scrivito routes. Adapt them to change the routing of CMS objects.
  # See the documentation of 'scrivito_route' for a detailed description.
  scrivito_route '/', using: 'homepage'
  scrivito_route '(/)(*slug-):id', using: 'slug_id'
  scrivito_route '/(*permalink)/(:slug)', using: 'permalink', format: false

  #work around to get search_url working...this route should not actually match
  #b/c scrivito above will catch it
  get 'search/(:slug)', to: redirect('/search?slug=%{slug}'), as: 'search'


end
