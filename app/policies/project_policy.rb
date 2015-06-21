class ProjectPolicy < ApplicationPolicy

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
    # The admin and the manager can modify the workGroup
    user.present? && ((user.has_role? :admin) || (user.has_role? :manager, record))
  end

  def destroy?
    # The admin and the manager can delete the workGroup
    user.present? && ((user.has_role? :admin) || (user.has_role? :manager, record) || (user.has_role? :owner, record.work_group))
  end

  def join?
    user.present?
  end

  def leave?
    user.present?
  end

end
