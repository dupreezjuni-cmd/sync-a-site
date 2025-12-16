Rails.application.routes.draw do
  # Simple Devise routes without deprecated syntax
  devise_for :users
  
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