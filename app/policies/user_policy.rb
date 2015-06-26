class UserPolicy < ApplicationPolicy

  def show?
    super
  end

  def show_projects?
    user.present?
  end

  def inbox?
    (user == record) || (user.has_role? :admin)
  end

  def sent?
    (user == record) || (user.has_role? :admin)
  end

  def trash?
    (user == record) || (user.has_role? :admin)
  end


end
