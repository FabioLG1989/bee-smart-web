Rails.application.routes.draw do
  root 'apiaries#index'
  resources :apiaries
  resources :hives, only: [:show] do
    member do
      get :close, to: 'hives#close'
      get :open, to: 'hives#open'
    end
  end
end
