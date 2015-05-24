class StandUpsController < ApplicationController
  def index
    @standUps = StandUp.all
  end

  def show
    @standUp = StandUp.find(params[:id])
    @standUps = looking_yesterday(@standUp.created_at)
  end

  def new
    @standUp = StandUp.new
    @standUps = looking_yesterday(DateTime.current)
    @standUp.tasks.build
    @standUp.blockers.build
  end

  def create
    @standUp = StandUp.new(stand_up_params)
    @standUp.user = current_user
    if @standUp.save!
      redirect_to @standUp
    else
      @standUps = looking_yesterday(DateTime.current)
      render 'new'
    end
  end

  def edit
    @standUp = StandUp.find(params[:id])
    @standUps = looking_yesterday(@standUp.created_at)
  end

  def update
    @standUp = StandUp.find(params[:id])

    if @standUp.update(stand_up_params)
      redirect_to @standUp
    else
      render 'edit'
    end
  end

  private

  def looking_yesterday(date)
    StandUp.where("user_id = :user AND created_at <= :stand_date",
  {user: current_user, stand_date: date})
    .order(created_at: :desc)
    .limit(2)
  end

  def stand_up_params
    params.require(:stand_up).permit(tasks_attributes: [:title, :description, :id], blockers_attributes: [:title, :description, :id])
  end
end
