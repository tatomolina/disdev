class StandUpsController < ApplicationController
  def index
    @standUps = StandUp.all
  end

  def show
    @standUp = StandUp.find(params[:id])
  end
end
