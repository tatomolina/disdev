class BlockersController < ApplicationController
  #Blockers are the problems that the user may encounter developing their apps
  # and they will describe them in here
  #In this controller is defined a base CRUD
  def show
    @blocker = Blocker.find(params[:id])
    authorize @blocker
  end

  def new
    @blocker = Blocker.new
    authorize Blocker
  end

  def create
		@blocker = Blocker.new(blocker_params)
    authorize @blocker
		@blocker.save!
    # Creates an activity to then show as a notification
    @blocker.create_activity :create, owner: current_user
		redirect_to @blocker
  end

  def edit
    @blocker = Blocker.find(params[:id])
    authorize @blocker
  end

  def update
		@blocker = Blocker.find(params[:id])
    authorize @blocker

		if @blocker.update(blocker_params)
      # Creates an activity to then show as a notification
      @blocker.create_activity :update, owner: current_user
			redirect_to @blocker
		else
			render 'edit'
		end
  end

  def destroy
		@blocker = Blocker.find(params[:id])
    authorize @blocker
		@blocker.destroy
    @blocker.create_activity :destroy, owner: current_user

		redirect_to stand_ups_path
  end
private

	def blocker_params
		params.require(:blocker).permit(:title, :description)
	end
end
