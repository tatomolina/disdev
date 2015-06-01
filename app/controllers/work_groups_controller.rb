class WorkGroupsController < ApplicationController

  def index
    authorize WorkGroup
    @workGroups = WorkGroup.search(params[:search])
  end

  def show
    @workGroup = WorkGroup.find(current_user.work_group.id)
    authorize @workGroup
  end

  def new
    authorize WorkGroup
    @workGroup = WorkGroup.new
  end

  def create
    @workGroup = WorkGroup.new(work_group_params)
    authorize @workGroup
    if@workGroup.save
      current_user.work_group = @workGroup
      current_user.add_role :manager
      current_user.save
      redirect_to @workGroup
    else
      render 'new'
    end
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
      #If i cant update, i render again the edit view
			render 'edit'
		end
  end

  def destroy
		@workGroup = WorkGroup.find(params[:id])
    authorize @workGroup
		@workGroup.delete_all

		redirect_to tasks_path
  end

  def manage
    @workGroup = WorkGroup.find(current_user.work_group.id)
    authorize @workGroup
  end

  def add_user
    @user = User.find_by email: params[:email]
    if @user.present?
      @user.work_group = WorkGroup.find(params[:workGroup])
      @user.save!
    else
      flash[:alert] = "nonexistent user"
    end
    authorize WorkGroup
    redirect_to manage_path
  end

  def remove_user
    @user = User.find(params[:id])
    @user.work_group = nil
    @user.save!
    authorize WorkGroup
    redirect_to manage_path
  end

  private

  	def work_group_params
      #Permit the name attribute
  		params.require(:work_group).permit(:name)
  	end

end