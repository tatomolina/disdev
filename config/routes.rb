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

  get 'root_assgin' => 'root_assignment#root_assign'

  resources :users, only: [:show] # I only permit show route
  resources :blockers, except: [:index] # Dont want an index route
  resources :tasks, except: [:index] # Dont want an index route
  resources :work_groups

  get '/work_groups/:id/manage', to: 'work_groups#manage', as: 'manage'
  post '/work_groups/:id/add_user', to: 'work_groups#add_user', as: 'add_user'
  post '/work_groups/:id/remove_user', to: 'work_groups#remove_user', as: 'remove_user'

  resources :projects do
    resources :stand_ups, except: [:index], shallow: true
  end

  post '/projects/:id/join', to: 'projects#join', as: 'join'
  post '/projects/:id/leave', to: 'projects#leave', as: 'leave'

  get 'home'        => 'static_pages#home'
  get 'help'        => 'static_pages#help'
  get 'about'       => 'static_pages#about'
  get 'contact'     => 'static_pages#contact'
  get 'new_user'    => 'static_pages#new_user'
end
