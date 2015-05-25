Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  devise_for :users

  devise_scope :user do
    authenticated :user do
      root 'work_groups#show', as: :authenticated_root
    end

    unauthenticated do
      root 'static_pages#home', as: :unauthenticated_root
    end
  end

  resources :work_groups
  resources :stand_ups
  resources :blockers, only: [:show, :new, :create, :edit, :update, :destroy]
  resources :tasks, only: [:show, :new, :create, :edit, :update, :destroy]
  root 'stand_ups#index'

get 'home'    => 'static_pages#home'
get 'help'    => 'static_pages#help'
get 'about'   => 'static_pages#about'
get 'contact' => 'static_pages#contact'
get 'new_user' => 'static_pages#new_user'
end
