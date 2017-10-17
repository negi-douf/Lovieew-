Rails.application.routes.draw do
  devise_for :users
  resources :reviews

  root "reviews#index"
end
