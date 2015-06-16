class ProjectsController < ApplicationController

  def index
    authorize Project
    @projects = Project.all
  end

  def show
    @project = Project.find(params[:id])
    authorize @project
  end

  def new
    authorize Project
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    authorize @project
    if @project.save
      @project.add! current_user
      current_user.add_role :manager, @project
      redirect_to @project
    else
      render 'new'
    end
  end

  def edit
    @project = Project.find(params[:id])
    authorize @project
  end

  def update
		@project = Project.find(params[:id])
    authorize @project

		if @project.update(project_params)
			redirect_to @project
		else
      #If i cant update, i render again the edit view
			render 'edit'
		end
  end

  def destroy
		@project = Project.find(params[:id])
    authorize @project
		@project.destroy

		redirect_to projects_path
  end

  def join
    @project = Project.find(params[:id])
    authorize @project
    @project.add! current_user
    redirect_to project_path @project
  end

  def leave
    @project = Project.find(params[:id])
    authorize @project
    @project.remove! current_user
    redirect_to work_group_path(@project.work_group)
  end

  private

  	def project_params
      #Permit the name attribute
  		params.require(:project).permit(:name)
  	end

end
