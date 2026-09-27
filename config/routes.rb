Rails.application.routes.draw do
  devise_for :users

  get "my_posts", to: "posts#my_posts"

  resources :posts do
    resources :comments, only: [:create, :destroy]
  end

  namespace :admin do
    resources :posts, only: [:index] do
      member do
        patch :approve
        patch :reject
      end
    end
    resources :comments, only: [:index, :destroy] do
      member do
        patch :restore
      end
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check

  root "posts#index"
end