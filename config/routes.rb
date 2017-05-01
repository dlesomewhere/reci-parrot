Rails.application.routes.draw do
  # ...auth...
  resources :sessions, only: [:create, :destroy]
  resources :shares, only: [:create, :index]

  # omniauth
  get 'auth/google_oauth2', to: 'sessions#create', as: 'signin'
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')

  # password
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#login_attempt'

  get 'signup', to: 'users#new'
  post 'signup', to: 'users#create'

  # general
  get 'signout', to: 'sessions#destroy', as: 'signout'

  # ...application...
  resources :recipes
  root "landing_pages#index"
end
