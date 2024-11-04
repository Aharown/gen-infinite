Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  resources :posts do
    get 'category/:category_id', to: 'posts#index', as: :category_posts, on: :collection
    resources :answers, only: [:create, :edit, :update, :destroy]
  end
  
  resources :users, only: [:show]
  resources :tags, except: [:edit, :update]
  resources :categories, only: [:show]

  # Defines the root path route ("/")
  # root "posts#index"
end
