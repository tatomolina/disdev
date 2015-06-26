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
    @active_group = :show
    authorize @workGroup
  end

  def show_projects
    @workGroup = WorkGroup.find(params[:id])
    @active_group = :show_projects
    authorize @workGroup
  end

  def show_manage
    @workGroup = WorkGroup.find(params[:id])
    @active_group = :show_manage
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
      flash[:notice] = "WorkGroup succesfully edited"
      redirect_to @workGroup
    else
      flash[:alert] = "#{@workGroup.errors.count} errors prohibited this workGroup from being saved: "
      @workGroup.errors.full_messages.each do |msg|
        flash[:alert] << "#{msg}"
        flash[:alert] << ", " unless @workGroup.errors.full_messages.last == msg
      end
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
      # Show a msg and then redirect to manage again
      flash[:notice] = "WorkGroup succesfully edited"
			redirect_to work_group_manage_path(@workGroup)
		else
      # If I cant update, I show a msg and render again the edit view
      if @workGroup.errors.any?
        flash[:alert] = "#{@workGroup.errors.count} errors prohibited this workGroup from being saved: "
        @workGroup.errors.full_messages.each do |msg|
          flash[:alert] << "#{msg}"
          flash[:alert] << ", " unless @workGroup.errors.full_messages.last == msg
        end
      end
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
      group = WorkGroup.find(params[:id])
      group.add! @user
      subject = "Joined to WorkGroup"
      body = "Congrats you just had been added to the workGroup #{group.name}.
      Now Join some project you want to work in and start creating standUps to
      comunicate your friends what are you doing"
      current_user.send_message(@user, body, subject)
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
    recipients = User.with_role :owner, work_group
    authorize work_group

    subject = "Request for Join"
    body = "The user #{current_user.email}
     is asking to join him to the #{work_group.name} WorkGroup"
    current_user.send_message(recipients, body, subject)
    flash[:notice] = "Your message was successfully sent!"
    redirect_to work_groups_path
  end

  def assign_roles
    # TODO assign roles
    redirect_to work_group_manage_path
  end


  private

  	def work_group_params
      #Permit the name attribute
  		params.require(:work_group).permit(:name)
  	end

end
