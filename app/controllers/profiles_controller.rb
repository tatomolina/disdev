class ProfilesController < ApplicationController
  after_action :verify_authorized
  def edit
    @profile = current_user.profile
    authorize @profile
  end

  def update
    @profile = current_user.profile
    authorize @profile
    if @profile.update!(profile_params)
      flash[:notice] = "Your profile has been updated."
      redirect_to user_path(current_user)
    else
      if @profile.errors.any?
        flash[:alert] = "#{@profile.errors.count} error prohibited this StandUp from being saved: "
        @profile.errors.full_messages.each do |msg|
          flash[:alert] << "#{msg} "
        end
      end
      render 'edit'
    end
  end

private

 def profile_params
   params.require(:profile).permit(:first_name, :last_name, :date_of_birth)
 end

end
