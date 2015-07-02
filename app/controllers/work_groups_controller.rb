class WorkGroupsController < ApplicationController

  def index
    authorize WorkGroup
    @workGroups = WorkGroup.search(params[:search])
    .paginate(:page => params[:page], :per_page => 6)
    .order("created_at desc")
  end

  def show
    @workGroup = WorkGroup.find(params[:id])
    # Notifications
    @activities = PublicActivity::Activity
    .all
    .order("created_at desc")
    # Assign wich nav-bar link should be active
    @active_group = :show
    authorize @workGroup
  end

  def show_projects
    @workGroup = WorkGroup.find(params[:id])
    # Assign wich nav-bar link should be active
    @active_group = :show_projects
    authorize @workGroup
  end

  def show_manage
    @workGroup = WorkGroup.find(params[:id])
    # Assign wich nav-bar link should be active
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
    if @workGroup.save
      @workGroup.add! current_user
      flash[:notice] = "WorkGroup succesfully created"
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
    @active_group = :show_manage
  end

  def update
		@workGroup = WorkGroup.find(params[:id])
    authorize @workGroup

		if @workGroup.update(work_group_params)
      # Show a msg and then redirect to manage again

      # Creates an activity to then show as a notification
      @workGroup.create_activity :update, owner: current_user
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

    @workGroup.users.each do |user|
      @workGroup.remove_roles user
    end
    
		if @workGroup.destroy
      flash[:notice] = "Work Group correctly deleted"
      redirect_to user_path(current_user)
    else
      flash[:alert] = "Could not destroy Work Group"
      current_user.add_role :owner, @workGroup
		  redirect_to work_group_path(@workGroup)
    end

  end

  def add_user
    #Looks for a user by the email passed by params
    @user = User.find_by email: params[:email]
    #if find it, add it to the work group if not flash msg
    @workGroup = WorkGroup.find(params[:id])
    authorize @workGroup
    if @user.present?
      # Creates an activity to then show as a notification
      @workGroup.create_activity :add_user, owner: @user
      @workGroup.add! @user
      # I send him an email to inform that he just being added to the group
      subject = "Joined to WorkGroup"
      body = "Congrats you just had been added to the workGroup #{@workGroup.name}.
      Now Join some project you want to work in and start creating standUps to
      comunicate your friends what are you doing"
      current_user.send_message(@user, body, subject)
      flash[:notice] = "User added correctly"
    else
      flash[:alert] = "Nonexistent user"
    end
    redirect_to work_group_manage_path(params[:id])
  end

  def remove_user
    #Look for the user passed by params and remve it from the group
    @user = User.find(params[:user_id])
    @work_group = WorkGroup.find(params[:id])
    authorize @work_group
    @work_group.remove! @user
    if @user.has_role? :owner, @work_group
      @work_group.assign_owner
    end
    @work_group.remove_roles @user
    redirect_to work_group_manage_path(@work_group)
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
    redirect_to request.referrer
  end

  def assign_roles
    @work_group = WorkGroup.find(params[:id])
    authorize @work_group
    user_ids = []
    params[:roles].each do |role|
      user_ids << role.last
    end
    user_ids = user_ids.to_set.to_a
    @users = User.find(user_ids)
    @users.each do |user|
      params[:roles].each do |role|
        role = role.split(" ")
        if((user.id == role.last.to_i) && (role.first == "nil"))
          user.remove_role role.second, @work_group
        elsif((user.id == role.last.to_i) && (role.first != "nil"))
          user.add_role role.first, @work_group
        end
      end
    end
    flash[:notice] = "Roles correctly apply"
    redirect_to work_group_manage_path
  end


  private

  	def work_group_params
      #Permit the name attribute
  		params.require(:work_group).permit(:name)
  	end

end
