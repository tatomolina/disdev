class WorkGroupsController < ApplicationController

  def index
    authorize WorkGroup
    @workGroups = WorkGroup.search(params[:search])
  end

  def show
    @workGroup = WorkGroup.find(params[:id])
    @activities = PublicActivity::Activity
    .paginate(:page => params[:page], :per_page => 5)
    .order("created_at desc")
    authorize @workGroup
  end

  def show_projects
    @workGroup = WorkGroup.find(params[:id])
    authorize @workGroup
  end

  def show_chat
    @workGroup = WorkGroup.find(params[:id])
    authorize @workGroup
  end

  def show_manage
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
      @workGroup.add! current_user
      current_user.add_role :owner, @workGroup
      current_user.save!
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

  def add_user
    #Looks for a user by the email passed by params
    @user = User.find_by email: params[:email]
    #if find it, add it to the work group if not flash msg
    if @user.present?
      WorkGroup.find(params[:id]).add! @user
    else
      flash[:alert] = "Nonexistent user"
    end
    authorize WorkGroup
    redirect_to work_group_manage_path(params[:id])
  end

  def remove_user
    #Look for the user passed by params and remve it from the group
    @user = User.find(params[:user_id])
    authorize WorkGroup
    WorkGroup.find(params[:id]).remove! @user
    redirect_to work_group_manage_path(params[:id])
  end

  def request_for_join
    work_group = WorkGroup.find(params[:work_group_id])
    owners = User.with_role :owner, work_group
    authorize work_group

    subject = "Request for Join"
    body = "The user #{current_user.email} is asking to join him to the #{work_group.name} WorkGroup"
    receipts = []
    owners.each do |owner|
      receipts << owner.notify(subject, body, current_user)
    end
    if Mailboxer::Notification.successful_delivery?(receipts)
      flash[:notice] = "Request sent to the owners group"
    else
      flash[:alert] = "An error ocurred, try again later"
    end
    redirect_to work_groups_path
  end


  private

  	def work_group_params
      #Permit the name attribute
  		params.require(:work_group).permit(:name)
  	end

end
