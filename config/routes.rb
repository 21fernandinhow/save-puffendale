Rails.application.routes.draw do
  get "errors/not_found"
  get "errors/internal_server_error"

  # Root
  root "home#index"

  # Health check & PWA
  get "up", to: "rails/health#show", as: :rails_health_check
  get "service-worker", to: "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest", to: "rails/pwa#manifest", as: :pwa_manifest

  # Authentication
  get "signup", to: "users#new"
  post "signup", to: "users#create"
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  # Home
  get "home", to: "home#index"

  # Village
  get "village", to: "village#index"

  # TaskLists and Tasks
  resources :task_lists do
    resources :tasks
  end

  # Error handling
  match "/404", to: "errors#not_found", via: :all
  match "/500", to: "errors#internal_server_error", via: :all
  
end