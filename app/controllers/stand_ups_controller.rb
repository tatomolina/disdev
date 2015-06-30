class StandUpsController < ApplicationController

  def show
    # Look for the standUp passed by params
    @standUp = StandUp.find(params[:id])
    authorize @standUp
    # Look for the last two stand_up's to then render the appropiate one and to
    # link to the previous stand_up
    @standUps = StandUp.looking_yesterday(@standUp.created_at, @standUp.user, @standUp.project)
    # Look for the next stand_up to link to the next stand_up
    @next_standUp = StandUp.next_stand_up(@standUp.created_at, @standUp.user, @standUp.project)
    # Assign wich nav-bar link should be active
    @active_project = :show
  end

  def new
    authorize StandUp
    @standUp = StandUp.new
    @project = Project.find(params[:project_id])
    #Need to show the last stanUp
    @standUps = StandUp.looking_yesterday(DateTime.current, current_user, @project)
    #I do this so i can show the text fields inside the fields_for
    @standUp.tasks.build
    @standUp.blockers.build
    # Assign wich nav-bar link should be active
    @active_project = :show
  end

  def create
    # Create a standUp only with the params that are permited
    @standUp = StandUp.new(stand_up_params)
    #Assign the current user to the recent created standUp
    @standUp.user = current_user
    #Assign the project to the recent created standUp
    @project = Project.find(params[:project_id])
    @standUp.project = @project

    authorize @standUp
    if @standUp.save
      # Creates an activity to then show as a notification
      @standUp.create_activity :create, owner: current_user
      # redirect to the show view of the recent creates standUp
      flash[:notice] = "StandUp correctly created"
      redirect_to stand_up_path(@standUp)
    else
      if @standUp.errors.any?
          flash[:alert] = "#{@standUp.errors.count} error prohibited this StandUp from being saved: "
        @standUp.errors.full_messages.each do |msg|
          flash[:alert] << "#{msg} "
        end
      end

      #If something go wrongs i need to search for the last standUp to render new
      @standUps = StandUp.looking_yesterday(DateTime.current, current_user, @project)
      render 'new'
    end
  end

  def edit
    @standUp = StandUp.find(params[:id])
    authorize @standUp
    # Assign wich nav-bar link should be active
    @active_project = :show
    #Look for the last two standUp's
    @standUps = StandUp.looking_yesterday(@standUp.created_at, @standUp.user, @standUp.project)
    # Look for the next stand_up to link to 
    @next_standUp = StandUp.next_stand_up(@standUp.created_at, @standUp.user, @standUp.project)
  end

  def update
    @standUp = StandUp.find(params[:id])
    authorize @standUp

    if @standUp.update(stand_up_params)
      # Creates an activity to then show as a notification
      @standUp.create_activity :update, owner: current_user
      flash[:notice] = "StandUp correctly updated"
      redirect_to @standUp
    else
      if @standUp.errors.any?
        flash[:alert] = "#{@standUp.errors.count} error prohibited this StandUp from being saved: "
        @standUp.errors.full_messages.each do |msg|
          flash[:alert] << "#{msg} "
        end
      end
      #If something go wrongs i need to search for the last standUp to render edit
      @standUps = StandUp.looking_yesterday(@standUp.created_at, @standUp.user, @standUp.project)
      render 'edit'
    end
  end

  def destroy
		@standUp = StandUp.find(params[:id])
    authorize @standUp
    @project = @standUp.project
    # Creates an activity to then show as a notification
    @standUp.create_activity :destroy, owner: current_user
		if @standUp.destroy
      flash[:notice] = "StandUp correctly destroyed"
		  redirect_to project_path(@project)
    else
      flash[:notice] = "StandUp couldn't be destroyed"
      redirect_to stand_up_path(@standUp)
    end
  end

  private

  def stand_up_params
    #Permit the tasks and blockers attributes that came inside the fields_for
    params.require(:stand_up).permit(tasks_attributes: [:description, :id, :_destroy],
    blockers_attributes: [:title, :description, :id, :_destroy])
  end
end
