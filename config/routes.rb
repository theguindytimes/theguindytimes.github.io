Rails.application.routes.draw do
  post '/rate' => 'rater#create', :as => 'rate'
  mount Ckeditor::Engine => '/ckeditor'
  resources :articles do
      resources :ratings, only: [:new, :show]
  end

  root :to => "home#index"
  devise_for :users, :controllers => {:registrations => "registrations"}
  resources :users
  get 'tags/:tag', to: 'articles#index', as: :tag
  get 'admin-login', to: 'home#adminLogin'

  get '/auth/:provider/callback' => 'authentications#create'
  delete '/authentications"' => 'authentications#destroy'
end
