Rails.application.routes.draw do
  # Devise routes with custom controllers
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords',
    confirmations: 'users/confirmations',
    unlocks: 'users/unlocks'
  }
  
  # Root path
  root "home#index"
  
  # Dashboard route
  get "dashboard", to: "dashboard#index"
  
  # Placeholder routes for future
  namespace :agency do
    get "dashboard", to: "dashboard#index"
    resources :tenants
    resources :users
  end
  
  namespace :client do
    get "dashboard", to: "dashboard#index"
    # Future client routes here
  end
end