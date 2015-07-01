class ProjectPolicy < ApplicationPolicy

  def show?
    (user.present?) && ((record.member? user) || (user.has_role? :admin))
  end

  def show_activities?
    (user.present?) && ((record.member? user) || (user.has_role? :admin))
  end

  def show_blockers?
    (user.present?) && (((record.member? user) && (user.has_role? :scrum_master,
     record)) || (user.has_role? :admin) || (user.has_role? :manager, record))
  end

  def show_manage?
    (user.present?) && (((record.member? user) && (user.has_role? :manager, record)) || (user.has_role? :admin))
  end

  def new?
    user.present? && ((user.work_groups.present?) || (user.has_role? :admin))
  end

  def create?
    user.present? && ((user.has_role? :admin) || (record.work_group.member? user))
  end

  def edit?
    # The admin and the manager can modify the workGroup
    user.present? && ((user.has_role? :admin) || (user.has_role? :manager, record))
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
    user.present? && (((record.work_group.member? user) && ( not record.member? user)) || (user.has_role? :admin))
  end

  def leave?
    user.present? && ((record.member? user) || (user.has_role? :admin))
  end

  def assign_roles?
    user.present? && ((user.has_role? :manager, record) || (user.has_role? :admin))
  end

end
