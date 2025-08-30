Rails.application.routes.draw do
  get "home/index"
  get "sessions/new"
  root "sessions#root_redirect"

  get "signup", to: "users#new"
  post "signup", to: "users#create"

  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  get "home", to: "home#index"

  resources :task_lists, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
    resources :tasks, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  end

  # Health check e PWA
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end