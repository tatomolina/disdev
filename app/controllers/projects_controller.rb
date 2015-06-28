class ProjectsController < ApplicationController

  def index
    authorize Project
    @projects = Project.all
  end

  def show
    @project = Project.find(params[:id])
    @active_project = :show
    authorize @project
    add_breadcrumb @project.name, project_path(@project)
  end

  def show_activities
    @project = Project.find(params[:id])
    @active_project = :show_activities
    @activities = PublicActivity::Activity
    .paginate(:page => params[:page], :per_page => 5)
    .order("created_at desc")
    authorize @project
  end

  def show_blockers
    @project = Project.find(params[:id])
    @active_project = :show_blockers
    @activities = PublicActivity::Activity
    .paginate(:page => params[:page], :per_page => 5)
    .order("created_at desc")
    authorize @project
  end

  def show_manage
    @project = Project.find(params[:id])
    @active_project = :show_manage
    authorize @project
  end

  def new
    authorize Project
    @project = Project.new
    @workGroup = WorkGroup.find(params[:work_group])
  end

  def create
    @project = Project.new(project_params)
    authorize @project
    @project.work_group = WorkGroup.find(params[:work_group_id])
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
    @project = Project.find(params[:project_id])
    authorize @project
    @project.add! current_user
    redirect_to project_path @project
  end

  def leave
    @project = Project.find(params[:project_id])
    # If the manager is leaving I need to assign that role to other user
    @project.remove! current_user
    if current_user.has_role? :manager, @project
      @project.assign_manager
    end
    authorize @project
    @project.remove_roles current_user
    redirect_to work_group_path(@project.work_group)
  end

  def assign_roles
    @project = Project.find(params[:id])
    @users = User.find(params[:members])
    @users.each do |user|
      params[:roles].each do |role|
        user.add_role role, @project
      end
    end
    flash[:notice] = "Roles correctly assigned"
    redirect_to project_manage_path
  end

  private

  	def project_params
      #Permit the name attribute
  		params.require(:project).permit(:name, :work_group_id)
  	end

end
