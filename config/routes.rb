Rails.application.routes.draw do
  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root "admin/dashboard#index"
  # resources :apiaries
  # resources :hives, only: [:show] do
  #   member do
  #     get :close, to: 'hives#close'
  #     get :open, to: 'hives#open'
  #   end
  # end
end
