class StaticPagesController < ApplicationController
skip_before_action :authenticate_user!, :only => [:home, :about, :help]
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
end
