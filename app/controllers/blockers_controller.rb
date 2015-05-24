class BlockersController < ApplicationController
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
			redirect_to @blocker
		else
			render 'edit'
		end
  end

  def destroy
		@blocker = Blocker.find(params[:id])
    authorize @blocker
		@blocker.destroy

		redirect_to blockers_path
  end
private

	def blocker_params
		params.require(:blocker).permit(:title, :description)
	end
end
