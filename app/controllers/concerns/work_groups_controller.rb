class WorkGroupsController < ApplicationController

  def show
    if current_user.work_group.present?
      @workGroup = WorkGroup.find(current_user.work_group.id)
      authorize @workGroup
    else
      redirect_to new_user_path
    end
  end

  def new
    authorize WorkGroup
    @workGroup = WorkGroup.new
  end

  def create
    @workGroup = WorkGroup.new(work_group_params)
    authorize @workGroup
    @workGroup.save!
    current_user.work_group = @workGroup
    current_user.save!
    redirect_to @workGroup
  end

  def edit
    @workGroup = WorkGroup.find(params[:id])
    authorize @workGroup
  end

  def update
		@workGroup = WorkGroup.find(params[:id])
    authorize @workGroup

		if @workGroup.update(work_group_params)
			redirect_to @workGroup
		else
			render 'edit'
		end
  end

  def destroy
		@workGroup = WorkGroup.find(params[:id])
    authorize @workGroup
		@workGroup.destroy

		redirect_to tasks_path
  end

  private

  	def work_group_params
  		params.require(:work_group).permit(:name)
  	end

end
