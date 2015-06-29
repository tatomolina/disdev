class StandUpsController < ApplicationController


  def index
    #limit the search to 10 to show only the last 10 standUp's of the current user
    authorize StandUp
    @standUps = StandUp
    .where("user_id = :user", {user: current_user})
    .limit(10)
    .order(created_at: :desc)
  end

  def show
    #Look for the standUp passed by params
    @standUp = StandUp.find(params[:id])
    authorize @standUp
    #Look for the last two standUp's
    @standUps = looking_yesterday(@standUp.created_at, @standUp.user, @standUp.project)
    @next_standUp = next_stand_up(@standUp.created_at, @standUp.user, @standUp.project)
    @project = @standUp.project
    @active_project = :show
  end

  def new
    authorize StandUp
    @standUp = StandUp.new
    @project = Project.find(params[:project_id])
    #Need to show the last stanUp
    @standUps = looking_yesterday(DateTime.current, current_user, @project)
    #I do this so i can show the text fields inside the fields_for
    @standUp.tasks.build
    @standUp.blockers.build
    @active_project = :show
  end

  def create
    @standUp = StandUp.new(stand_up_params)
    #Assign the current user to the recent created standUp
    @standUp.user = current_user
    @project = Project.find(params[:project_id])
    @standUp.project = @project

    authorize @standUp
    if @standUp.save
      # Every time I create a standUp I'm updating the project
      @standUp.project.updated_at = DateTime.current
      @standUp.project.save!
      # Creates an activity to then show as a notification
      @standUp.create_activity :create, owner: current_user
      # redirect to the show view of the recent creates standUp
      redirect_to @standUp
    else
      if @standUp.errors.any?
        flash[:alert] = "#{@standUp.errors.count} error prohibited this StandUp from being saved: "
        @standUp.errors.full_messages.each do |msg|
          flash[:alert] << "#{msg} "
        end
      end

      #If something go wrongs i need to search for the last standUp to render new
      @standUps = looking_yesterday(DateTime.current, current_user, @standUp.project)
      render 'new'
    end
  end

  def edit
    @standUp = StandUp.find(params[:id])
    authorize @standUp
    #Look for the last two standUp's
    @standUps = looking_yesterday(@standUp.created_at, @standUp.user, @standUp.project)
  end

  def update
    @standUp = StandUp.find(params[:id])
    authorize @standUp

    if @standUp.update(stand_up_params)
      # Creates an activity to then show as a notification
      @standUp.create_activity :update, owner: current_user
      redirect_to @standUp
    else
      if @standUp.errors.any?
        flash[:alert] = "#{@standUp.errors.count} error prohibited this StandUp from being saved: "
        @standUp.errors.full_messages.each do |msg|
          flash[:alert] << "#{msg} "
        end
      end
      #If something go wrongs i need to search for the last standUp to render edit
      @standUps = looking_yesterday(@standUp.created_at, @standUp.user, @standUp.project)
      render 'edit'
    end
  end

  def destroy
		@standUp = StandUp.find(params[:id])
    authorize @standUp
		@standUp.destroy
    @standUp.create_activity :destroy, owner: current_user

		redirect_to stand_ups_path
  end

  private

  def looking_yesterday(date, user, project)
    #Search for the last two standUp's
    StandUp.where("user_id = :user AND created_at <= :stand_date AND project_id = :project",
    {user: user, stand_date: date, project: project})
    .order(created_at: :desc)
    .limit(2)
  end

  def next_stand_up(date, user, project)
    #Search for the next two standUp's
    StandUp.where("user_id = :user AND created_at > :stand_date AND project_id = :project",
    {user: user, stand_date: date, project: project})
    .order(created_at: :asc)
    .limit(1)
  end

  def stand_up_params
    #Permit the tasks and blockers attributes that came inside the fields_for
    params.require(:stand_up).permit(tasks_attributes: [:description, :id, :_destroy],
    blockers_attributes: [:title, :description, :id, :_destroy])
  end
end
