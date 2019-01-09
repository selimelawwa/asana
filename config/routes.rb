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
  end



  
  resources :orders, only: %i[index show]
  post 'add_to_cart', to: 'orders#add_to_cart', as: 'add_to_cart'
  
  scope '/admin' do
    get 'products/list', to: 'products#list', as: 'product_list'
    resources :categories
    resources :sizes, only: %i[index new create edit update]
    resources :colors, only: %i[index new create edit update]
  end
  
  get 'welcome/index'
  root 'welcome#index'
end
