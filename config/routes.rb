Rails.application.routes.draw do
  resources :messages
  mount Ckeditor::Engine => '/ckeditor'
  resources :articles do 
    resources :comments
  end

  root :to => "home#index"
  devise_for :users, :controllers => {:registrations => "registrations"}
  resources :users
    resources :authentications
  get 'tags/:tag', to: 'articles#index', as: :tag
  get 'admin', to: 'users#admin'
  get 'admin-login', to: 'home#adminLogin'

  get '/auth/:provider/callback' => 'authentications#create'
  delete '/authentications"' => 'authentications#destroy'
end
