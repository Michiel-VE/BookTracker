Rails.application.routes.draw do
  # Defines the root path route ("/")
  root "main#index"
  
  get "books/search"

  resources :likes, only: [:create, :destroy]
  resources :read_books, only: [:create, :destroy]

  get 'profile', to: 'profile#show_profile', as: 'profile'
  patch 'profile/update_goal', to: 'profile#update_goal', as: 'update_goal'

  get 'books/liked', to: 'books#show_liked_books', as: 'liked'
  get 'books/read', to: 'books#show_read_books', as: 'read'
  
  devise_for :users, controllers: {
    registations: 'users-registations',
    sessions: 'users/sessions',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }


end
