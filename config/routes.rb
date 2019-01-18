Rails.application.routes.draw do
  devise_for :users,skip: [:passwords], controllers: {
        sessions: 'users/sessions',
        registrations: 'users/registrations'
  }
  devise_scope :user do
    get 'users/edit/password', to: 'users/registrations#edit_password', as: 'edit_user_password'
    put 'users/update_password', to: 'users/registrations#update_password', as: 'update_user_password'
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
    resources :categories
    resources :sizes, only: %i[index new create edit update]
    resources :colors, only: %i[index new create edit update]
    resources :tags do
      get 'available_products', to: 'tags#available_products', as: 'available_products'
      post 'assign_products', to: 'tags#assign_products', as: 'assign_products'
    end
  end
  
  get 'welcome/index'
  root 'welcome#index'
end
