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
    @standUps = looking_yesterday(@standUp.created_at, @standUp.user)
  end

  def new
    authorize StandUp
    @standUp = StandUp.new
    #Need to show the last stanUp
    @standUps = looking_yesterday(DateTime.current, current_user)
    #I do this so i can show the text fields inside the fields_for
    @standUp.tasks.build
    @standUp.blockers.build
  end

  def create
    @standUp = StandUp.new(stand_up_params)
    #Assign the current user to the recent created standUp
    @standUp.user = current_user
    authorize @standUp
    if @standUp.save
      #redirect to the show view of the recent creates standUp
      redirect_to @standUp
    else
      #If something go wrongs i need to search for the last standUp to render new
      @standUps = looking_yesterday(DateTime.current, current_user)
      render 'new'
    end
  end

  def edit
    @standUp = StandUp.find(params[:id])
    authorize @standUp
    #Look for the last two standUp's
    @standUps = looking_yesterday(@standUp.created_at, @standUp.user)
  end

  def update
    @standUp = StandUp.find(params[:id])
    authorize @standUp

    if @standUp.update(stand_up_params)
      redirect_to @standUp
    else
      #If something go wrongs i need to search for the last standUp to render edit
      @standUps = looking_yesterday(@standUp.created_at, @standUp.user)
      render 'edit'
    end
  end

  def destroy
		@standUp = StandUp.find(params[:id])
    authorize @standUp
		@standUp.destroy

		redirect_to stand_ups_path
  end

  private

  def looking_yesterday(date, user)
    #Search for the last two standUp's
    StandUp.where("user_id = :user AND created_at <= :stand_date",
    {user: user, stand_date: date})
    .order(created_at: :desc)
    .limit(2)
  end

  def stand_up_params
    #Permit the tasks and blockers attributes that came inside the fields_for
    params.require(:stand_up).permit(tasks_attributes: [:title, :description, :id],
    blockers_attributes: [:title, :description, :id])
  end
end
