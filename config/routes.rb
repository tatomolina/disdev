Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users
  resources :stand_ups
  resources :blockers
  resources :tasks
  root 'stand_ups#index'
end
