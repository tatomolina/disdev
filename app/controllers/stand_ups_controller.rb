class StandUpsController < ApplicationController
  def index
    authorize StandUp
    @standUps = StandUp
    .where("user_id = :user", {user: current_user})
    .limit(10)
    .order(created_at: :desc)
  end

  def show
    @standUp = StandUp.find(params[:id])
    authorize @standUp
    @standUps = looking_yesterday(@standUp.created_at)
  end

  def new
    authorize StandUp
    @standUp = StandUp.new
    @standUps = looking_yesterday(DateTime.current)
    @standUp.tasks.build
    @standUp.blockers.build
  end

  def create
    @standUp = StandUp.new(stand_up_params)
    @standUp.user = current_user
    authorize @standUp
    if @standUp.save!
      redirect_to @standUp
    else
      @standUps = looking_yesterday(DateTime.current)
      render 'new'
    end
  end

  def edit
    @standUp = StandUp.find(params[:id])
    authorize @standUp
    @standUps = looking_yesterday(@standUp.created_at)
  end

  def update
    @standUp = StandUp.find(params[:id])
    authorize @standUp

    if @standUp.update(stand_up_params)
      redirect_to @standUp
    else
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
