Rails.application.routes.draw do

  devise_for :users
  resources :reviews do
    collection do
      get "ranking"
      get "search"
      post "serch"
    end

    resources :comments
  end

  resources :users, only: [:index, :show] do
    resources :nices, only: [:index, :create, :destroy]
  end
  resources :relationships, only: [:create, :destroy]

  root "reviews#ranking"
end
