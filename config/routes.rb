Rails.application.routes.draw do
  # =========== PUBLIC ROUTES ===========
  root to: "home#index"
  get "up", to: "rails/health#show", as: :rails_health_check

  # =========== AUTHENTICATION ===========
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords'
  }

  # =========== DASHBOARD ===========
  get 'dashboard', to: 'dashboard#index'

  # =========== ADMIN ROUTES ===========
  namespace :admin do
    # Feature management
    resources :features, only: [:index, :update]
    
    # Future admin routes can go here
    # resources :settings, only: [:index, :update]
    # resources :reports, only: [:index]
  end

  # =========== USER MANAGEMENT ===========
  resources :users, only: [:index, :show, :edit, :update, :destroy] do
    # Future nested routes for user management
    # resources :permissions, only: [:index, :update]
  end

  # =========== TENANT MANAGEMENT ===========
  resources :tenants, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
    # Future nested routes for tenant management
    # resources :subscriptions, only: [:index, :show]
    # resources :analytics, only: [:index]
  end

  # =========== AGENCY MANAGEMENT ===========
  resources :agencies, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
    # Future nested routes for agency management
    # resources :tenants, only: [:index]
    # resources :billing, only: [:index]
  end

  # =========== FEATURE-SPECIFIC ROUTES ===========
  # These can be added later when implementing specific features
  # scope module: :features do
  #   resources :blogs, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  #   resources :products, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  #   resources :contacts, only: [:index, :show, :new, :create]
  # end

  # =========== API ROUTES (Future) ===========
  # namespace :api do
  #   namespace :v1 do
  #     resources :users, only: [:index, :show]
  #     resources :tenants, only: [:index, :show]
  #   end
  # end

  # =========== ERROR HANDLING ===========
  # match '/404', to: 'errors#not_found', via: :all
  # match '/500', to: 'errors#internal_server_error', via: :all
  # match '*path', to: 'errors#not_found', via: :all
end