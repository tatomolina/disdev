class TasksController < ApplicationController

#Tasks are the principal issues the users are going to acomplish in their StandUps
#In this controller is defined a base CRUD

  def show
    @task = Task.find(params[:id])
    authorize @task
  end

  def new
    authorize Task
    @task = Task.new
  end

  def create
		@task = Task.new(task_params)
    authorize @task
		@task.save!
		redirect_to @task
  end

  def edit
    @task = Task.find(params[:id])
    authorize @task
  end

  def update
		@task = Task.find(params[:id])
    authorize @task

		if @task.update(task_params)
			redirect_to @task
		else
			render 'edit'
		end
  end

  def destroy
		@task = Task.find(params[:id])
    authorize @task
		@task.destroy

		redirect_to tasks_path
  end
private

	def task_params
		params.require(:task).permit(:title, :description)
	end
end
