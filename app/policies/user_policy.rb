class UserPolicy < ApplicationPolicy

  def show?
    super
  end

  def show_projects?
    user.present?
  end

end
