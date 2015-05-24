class BlockersController < ApplicationController
  def show
    @blocker = Blocker.find(params[:id])
  end

  def new
    @blocker = Blocker.new
  end

  def create
		@blocker = Blocker.new(blocker_params)
		@blocker.save!
		redirect_to @blocker
  end

  def edit
    @blocker = Blocker.find(params[:id])
  end

  def update
		@blocker = Blocker.find(params[:id])

		if @blocker.update(blocker_params)
			redirect_to @blocker
		else
			render 'edit'
		end
  end

  def destroy
		@blocker = Blocker.find(params[:id])
		@blocker.destroy

		redirect_to blockers_path
  end
private

	def blocker_params
		params.require(:blocker).permit(:title, :description)
	end
end
