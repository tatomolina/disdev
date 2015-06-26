Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  devise_for :users

  devise_scope :user do
    authenticated :user do
      root 'root_assignment#assign_root', as: :authenticated_root
    end

    unauthenticated do
      root 'static_pages#unauthenticated', as: :unauthenticated_root
    end
  end
  root 'static_pages#unauthenticated'

  # Profile
  get '/profile/edit',                  to: 'profiles#edit',                      as: 'edit_profile'
  patch '/profile',                     to: 'profiles#update'

  # Root assignment
  get 'root_assgin' => 'root_assignment#root_assign'

  # User
  resources :users, only: [:show] # I only permit show route
  get '/users/:id/projects',            to: 'users#show_projects',                as: 'user_projects'
  get '/users/:id/messages',            to: 'users#show_messages',                as: 'user_messages'

  get "/users/:id/inbox" => "mailbox#inbox", as: :mailbox_inbox
  get "/users/:id/sent" => "mailbox#sent", as: :mailbox_sent
  get "/users/:id/trash" => "mailbox#trash", as: :mailbox_trash

  # Conversations
  resources :conversations do
      member do
        post :reply
        post :trash
        post :untrash
      end
    end

  # Blocker
  resources :blockers, except: [:index] # Dont want an index route

  # WorkGroup
  resources :work_groups

  get '/work_groups/:id/projects',      to: 'work_groups#show_projects',          as: 'work_group_projects'
  get '/work_groups/:id/manage',        to: 'work_groups#show_manage',            as: 'work_group_manage'
  post '/work_groups/:id/assign_roles', to: 'work_groups#assign_roles',           as: 'work_group_assign_roles'
  post '/work_groups/:id/add_user',     to: 'work_groups#add_user',               as: 'add_user'
  post '/work_groups/:id/remove_user',  to: 'work_groups#remove_user',            as: 'remove_user'
  post '/work_groups/request_for_join', to: 'work_groups#request_for_join',       as: 'request_for_join'

  # Projet and nested StandUp
  resources :projects do
    resources :stand_ups, except: [:index], shallow: true
  end

  get  '/projects/:id/show_activities', to: 'projects#show_activities',           as: 'project_activities'
  get  '/projects/:id/show_manage',     to: 'projects#show_manage',               as: 'project_manage'
  post '/projects/:id/assign_roles',    to: 'projects#assign_roles',              as: 'project_assign_roles'
  post '/projects/:id/join',            to: 'projects#join',                      as: 'project_join'
  post '/projects/:id/leave',           to: 'projects#leave',                     as: 'project_leave'


  #Static Pages
  get 'home'        => 'static_pages#home'
  get 'help'        => 'static_pages#help'
  get 'about'       => 'static_pages#about'
  get 'contact'     => 'static_pages#contact'
  get 'new_user'    => 'static_pages#new_user'
end
