Rails.application.routes.draw do
  devise_for :users,skip: [:passwords], controllers: {
        sessions: 'users/sessions',
        registrations: 'users/registrations'
  }
  devise_scope :user do
    get 'users/edit/password', to: 'users/registrations#edit_password', as: 'edit_user_password'
    put 'users/update_password', to: 'users/registrations#update_password', as: 'update_user_password'
  end
  resources :products
  get 'welcome/index'
  root 'welcome#index'
end
