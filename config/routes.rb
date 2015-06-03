Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  devise_for :users

  devise_scope :user do
    authenticated :user do
      root 'root_assignment#assign_root', as: :authenticated_root
    end

    unauthenticated do
      root 'static_pages#home', as: :unauthenticated_root
    end
  end
  root 'static_pages#home'

  resources :users, only: [:show] # I only permit show route
  resources :work_groups
  resources :stand_ups
  resources :blockers, only: [:show, :new, :create, :edit, :update, :destroy]
  resources :tasks, only: [:show, :new, :create, :edit, :update, :destroy]

  get 'root_assgin' => 'root_assignment#root_assign'

  get '/work_group/:id/manage', to: 'work_groups#manage', as: 'manage'
  post '/work_group/:id/add_user', to: 'work_groups#add_user', as: 'add_user'
  post '/work_group/:id/remove_user', to: 'work_groups#remove_user', as: 'remove_user'

  get 'home'        => 'static_pages#home'
  get 'help'        => 'static_pages#help'
  get 'about'       => 'static_pages#about'
  get 'contact'     => 'static_pages#contact'
  get 'new_user'    => 'static_pages#new_user'
end
