Rails.application.routes.draw do

  devise_for :users
  resources :reviews do
    resources :comments
  end
  resources :users, only: [:index, :show]
  resources :relationships, only: [:create, :destroy]

  root "reviews#index"
end
