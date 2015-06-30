class BlockersController < ApplicationController
  #Blockers are the problems that the user may encounter developing their apps
  # and they will describe them in here

  #In this controller is defined only the
  def show
    @blocker = Blocker.find(params[:id])
    authorize @blocker
    # With this im assigning wich nav link should be marked as active in the nav-bar
    @active_project = :show
  end

  def edit
    @blocker = Blocker.find(params[:id])
    authorize @blocker
    # With this im assigning wich nav link should be marked as active in the nav-bar
    @active_project = :show
  end

  def update
		@blocker = Blocker.find(params[:id])
    authorize @blocker

		if @blocker.update(blocker_params)
      flash[:notice] = "Blocker correctly updated"
			redirect_to @blocker
		else
      if @blocker.errors.any?
        flash[:alert] = "#{@blocker.errors.count} error prohibited this StandUp from being saved: "
        @blocker.errors.full_messages.each do |msg|
          flash[:alert] << "#{msg} "
        end
      end
			render 'edit'
		end
  end

  def destroy
		@blocker = Blocker.find(params[:id])
    authorize @blocker
    @stand_up = @blocker.stand_up

    if @blocker.destroy
       flash[:notice] = "Blocker correctly destroyed"
		   redirect_to stand_up_path(@stand_up)
    else
       flash[:notice] = "Blocker couldn't be destroyed"
		   redirect_to blocker_path(@blocker)
    end
  end
private

	def blocker_params
		params.require(:blocker).permit(:title, :description)
	end
end
