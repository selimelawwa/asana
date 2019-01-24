Rails.application.routes.draw do
  devise_for :users,skip: [:passwords], controllers: {
        sessions: 'users/sessions',
        registrations: 'users/registrations'
  }
  devise_scope :user do
    get 'users/edit/password', to: 'users/registrations#edit_password', as: 'edit_user_password'
    put 'users/update_password', to: 'users/registrations#update_password', as: 'update_user_password'
    post  'check_email', to: 'users/registrations#check_email', as: 'check_email'
    post  'check_current_password', to: 'users/registrations#check_current_password', as: 'check_current_password'
  end
  resources :products do
    collection do
      match 'search' => 'products#search', via: [:get, :post], as: :search
    end
    resources :variants do 
      post '/update_stock', to: 'variants#update_stock', as: :update_stock
    end
    resources :images
    post 'publish', to: 'products#publish', as: 'publish'
  end

  # footer pages
  get 'exchange_and_refund', to: 'pages#exchange_and_refund', as: 'exchange_and_refund'
  get 'mission_and_vision', to: 'pages#mission_and_vision', as: 'mission_and_vision'
  get 'company_overview', to: 'pages#company_overview', as: 'company_overview'
  get 'core_values', to: 'pages#core_values', as: 'core_values'

  
  resources :orders, only: %i[index show] do
    get 'select_address', to: 'orders#select_address', as: 'select_address'
    post 'assign_address', to: 'orders#assign_address', as: 'assign_address'
    post 'create_address', to: 'orders#create_address', as: 'create_address'
    get 'confirm_details', to: 'orders#confirm_details', as: 'confirm_details'
    post 'confirm_order', to: 'orders#confirm_order', as: 'confirm_order'
  end
  get 'cart', to: 'orders#cart', as: 'cart'
  post 'add_to_cart', to: 'orders#add_to_cart', as: 'add_to_cart'
  post 'remove_line_item', to: 'orders#remove_line_item', as: 'remove_line_item'
  post 'update_line_item_quantity', to: 'orders#update_line_item_quantity', as: 'update_line_item_quantity'


  scope '/admin' do
    get 'products/list', to: 'products#list', as: 'product_list'
    resources :categories, except: :destroy do 
      resources :subcategories, except: :destroy
    end
    resources :sizes, only: %i[index new create edit update]
    resources :colors, only: %i[index new create edit update]
    resources :tags do
      get 'available_products', to: 'tags#available_products', as: 'available_products'
      post 'assign_products', to: 'tags#assign_products', as: 'assign_products'
      get 'assigned_products', to: 'tags#assigned_products', as: 'assigned_products'
      post 'remove_products', to: 'tags#remove_products', as: 'remove_products'
    end
    resources :slides, except: :show
    resources :jumbotrons, except: [:show, :destroy]
    resources :cities, except: [:show, :destroy]
    resource :vat, only: [:edit, :update]
  end
  
  get 'welcome/index'
  root 'welcome#index'
end
