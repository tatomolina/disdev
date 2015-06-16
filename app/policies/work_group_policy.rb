class WorkGroupPolicy < ApplicationPolicy

  def index?
    true
  end

  def show?
    (user.present?) && (record.member? user)
  end

  def create?
    user.present?
  end

  def new?
    user.present?
  end

  def update?
    #only the admin can modify the workGroup
    user.present? && (user.has_role? :admin)
  end

  def destroy?
    #only the admin can delete the workGroup
    user.present? && (user.has_role? :admin)
  end

  def manage?
    (user.present?) && ((user.has_role? :admin) || (user.has_role? :manager))
  end

  def add_user?
    (user.present?) && ((user.has_role? :admin) || (user.has_role? :manager))
  end

  def remove_user?
    (user.present?) && ((user.has_role? :admin) || (user.has_role? :manager))
  end

end
