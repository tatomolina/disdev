class WorkGroupPolicy < ApplicationPolicy

  def index?
    true
  end

  def show?
    (user.present?) && (record.member? user)
  end

  def show_projects?
    (user.present?) && (record.member? user)
  end

  def show_manage?
    (user.present?) && ((user.has_role? :admin) || (user.has_role? :owner, record))
  end

  def create?
    user.present?
  end

  def new?
    user.present?
  end

  def update?
    #only the admin can modify the workGroup
    user.present? && ((user.has_role? :admin) || (user.has_role? :owner, record))
  end

  def destroy?
    #only the admin can delete the workGroup
    user.present? && (user.has_role? :admin)
  end


  def add_user?
    (user.present?) && ((user.has_role? :admin) || (user.has_role? :manager))
  end

  def remove_user?
    (user.present?) && ((user.has_role? :admin) || (user.has_role? :manager))
  end

  def request_for_join?
    (user.present?) && ((user.has_role? :admin) || (not record.member? user))
  end

end
