class UsersController < ApplicationController

  def show
    if params.has_key? :id
      @user = User.find(params[:id])
    else
      @user = User.find(current_user)
    end
      authorize @user
  end

end
