class WorkGroupPolicy < ApplicationPolicy

  def index?
    true
  end

  def create?
    record.user == user
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

end
