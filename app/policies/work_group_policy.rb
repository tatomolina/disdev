class WorkGroupPolicy < ApplicationPolicy

  def index?
    user.present?
  end

  def show?
    (user.present?) && ((record.member? user) || (user.has_role? :admin))
  end

  def show_projects?
    (user.present?) && ((record.member? user) || (user.has_role? :admin))
  end

  def show_manage?
    (user.present?) && ((user.has_role? :admin) || (user.has_role? :owner, record))
  end

  def new?
    user.present?
  end

  def create?
    user.present?
  end

  def update?
    #only the owner or the admin can modify the workGroup
    user.present? && ((user.has_role? :admin) || (user.has_role? :owner, record))
  end

  def edit?
    #only the owner or the admin can modify the workGroup
    user.present? && ((user.has_role? :admin) || (user.has_role? :owner, record))
  end

  def destroy?
    #only the admin can delete the workGroup
    user.present? && ((user.has_role? :owner, record) || (user.has_role? :admin))
  end

  def add_user?
    (user.present?) && ((user.has_role? :admin) || (user.has_role? :owner, record))
  end

  def remove_user?
    (user.present?) && ((user.has_role? :admin) || (user.has_role? :owner, record))
  end

  def request_for_join?
    (user.present?) && ((user.has_role? :admin) || (not record.member? user))
  end

  def assign_roles?
    (user.present?) && ((user.has_role? :admin) || (user.has_role? :owner, record))
  end

end
