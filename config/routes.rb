Rails.application.routes.draw do
  resources :downloads

  resources :events

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
  get 'admin', to: 'home#admin'
  get 'admin-login', to: 'home#adminLogin'

  get '/auth/:provider/callback' => 'authentications#create'
  delete '/authentications"' => 'authentications#destroy'
  get 'autocomplete' => 'articles#autocomplete'
  get 'news/new' => 'articles#new_news'
  get 'news' => 'articles#index_news'

end
