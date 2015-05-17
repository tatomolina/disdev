Rails.application.routes.draw do
  resources :stand_ups
  root 'stand_ups#index'
end
