class StandUpsController < ApplicationController
  def index
    @standUps = StandUp.all
  end

  def show
    @StandUp = StandUp.find(params[:id])
  end
end
