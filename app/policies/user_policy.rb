class UserPolicy < ApplicationPolicy

  def show?
    super
  end

  def show_projects?
    (user.present?) && ((user == record) || (user.has_role? :admin))
  end

  def show_work_groups?
    (user.present?) && ((user == record) || (user.has_role? :admin))
  end

  def show_work_groups_guest?
    (user.present?) && ((user != record) || (user.has_role? :admin))
  end

  def inbox?
    (user.present?) && ((user == record) || (user.has_role? :admin))
  end

  def sent?
    (user.present?) && ((user == record) || (user.has_role? :admin))
  end

  def trash?
    (user.present?) && ((user == record) || (user.has_role? :admin))
  end


end
