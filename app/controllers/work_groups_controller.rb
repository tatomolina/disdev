class WorkGroupsController < ApplicationController

  def index
    authorize WorkGroup
    @workGroups = WorkGroup.search(params[:search])
  end

  def show
    @workGroup = WorkGroup.find(params[:id])
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
      current_user.join! @workGroup
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
		@workGroup.destroy

		redirect_to work_groups_path
  end

  def manage
    @workGroup = WorkGroup.find(params[:id])
    authorize @workGroup
  end

  def add_user
    #Looks for a user by the email passed by params
    @user = User.find_by email: params[:email]
    #if find it, add it to the work group if not flash msg
    if @user.present?
      @user.join! WorkGroup.find(params[:id])
      @user.save!
    else
      flash[:alert] = "Nonexistent user"
    end
    authorize WorkGroup
    redirect_to manage_path(params[:id])
  end

  def remove_user
    #Look for the user passed by params and remve it from the group
    @user = User.find(params[:user_id])
    authorize WorkGroup
    @user.leave! WorkGroup.find(params[:id])
    @user.save!
    redirect_to manage_path(params[:id])
  end

  private

  	def work_group_params
      #Permit the name attribute
  		params.require(:work_group).permit(:name)
  	end

end
