class WorkGroupsController < ApplicationController

  def index

  end

  def show
    @workGroup = WorkGroup.find(params[:id])
  end

end
