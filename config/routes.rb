Rails.application.routes.draw do
  get "home/index"
  get "sessions/new"
  # Página inicial quando não está logado
  root "sessions#new"

  # Registro de usuário
  get "signup", to: "users#new"
  post "signup", to: "users#create"

  # Login / Logout
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  # Home do usuário logado
  get "home", to: "home#index"

  # TaskLists e Tasks (cada usuário só verá os seus)
  resources :task_lists, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
    resources :tasks, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  end

  # Health check e PWA
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end