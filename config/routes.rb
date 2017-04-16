Rails.application.routes.draw do
  resources :recipes

  get 'auth/google_oauth2', to: 'sessions#create', as: 'signin'

  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'signout', to: 'sessions#destroy', as: 'signout'

  resources :sessions, only: [:create, :destroy]
  resources :shares, only: [:create, :index]

  root "landing_pages#index"
end
