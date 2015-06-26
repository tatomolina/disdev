class UsersController < ApplicationController

  def show
    if params.has_key? :id
      @user = User.find(params[:id])
    else
      @user = User.find(current_user)
    end
    @active_user = :show
      authorize @user
  end

  def show_projects
    if params.has_key? :id
      @user = User.find(params[:id])
    else
      @user = User.find(current_user)
    end
    @active_user = :show_projects
      authorize @user
  end

end
