Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
  resources :articles

  root :to => "home#index"
  devise_for :users, :controllers => {:registrations => "registrations"}
  resources :users
  get 'tags/:tag', to: 'articles#index', as: :tag
  get 'admin', to: 'users#admin'
  get 'admin-login', to: 'home#adminLogin'

  get '/auth/:provider/callback' => 'authentications#create'
  delete '/authentications"' => 'authentications#destroy'
end
