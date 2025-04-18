Rails.application.routes.draw do
  get "dashboard/index"
  root 'sessions#new'
  
  resources :users do
    member do
      post 'follow'
      post 'unfollow'
    end
  end
  resources :follows, only: [:create, :destroy]
  resources :sessions, only: [:new, :create, :destroy]
  resources :habits, except: [:new, :create] do
    resources :reminders, only: [:new, :create, :index, :destroy]
    resources :time_blocks, only: [:new, :create, :index, :edit, :update] do
      member do
        patch :start   # 开始时间块
        patch :finish  # 结束时间块
      end
    end
  end

  resources :categories, only: [:index] do
    resources :habits, only: [:new, :create]
  end
  
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  get 'dashboard', to: 'dashboard#index'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
