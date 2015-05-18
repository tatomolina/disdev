Rails.application.routes.draw do
  resources :stand_ups
  resources :blockers
  resources :tasks
  root 'stand_ups#index'
end
