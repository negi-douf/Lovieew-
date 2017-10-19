Rails.application.routes.draw do
  devise_for :users
  resources :reviews do
    resources :comments
  end

  root "reviews#index"
end
