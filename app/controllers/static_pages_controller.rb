class StaticPagesController < ApplicationController
skip_before_action :authenticate_user!, :only => [:unauthenticated, :about, :help]
skip_after_action :verify_authorized
  def home
  end

  def help
  end

  def about
  end

  def contact
  end

  def new_user
  end

  def unauthenticated
  end
end
