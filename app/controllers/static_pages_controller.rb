class StaticPagesController < ApplicationController
skip_before_action :authenticate_user!, :only => [:unauthenticated, :about, :help]
skip_after_action :verify_authorized
  def home
    @activities = PublicActivity::Activity
    .paginate(:page => params[:page], :per_page => 5)
    .order("created_at desc")
    @projects = current_user.projects
    .paginate(:page => params[:page], :per_page => 4)
    .order("created_at desc")
  end

  def help
  end

  def new_user
  end

  def unauthenticated
  end
end
