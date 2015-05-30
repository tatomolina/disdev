class RootAssignmentController < ApplicationController
  skip_after_action :verify_authorized

  def assign_root
    #Ask this to know if i recive a request to the root-path or y should show
    #some users page
    if current_user.work_group.present?
      redirect_to work_group_path(current_user)
    else
      redirect_to new_user_path
    end
  end

end
