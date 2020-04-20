Rails.application.routes.draw do
  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root "admin/apiaries#index"
  mount ActionCable.server => '/cable'
end
