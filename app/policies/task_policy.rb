class TaskPolicy < ApplicationPolicy

  def create?
    record.user == user
  end

  def new?
    user.present?
  end

  def update?
    ((record.stand_up.user == user) && (DateTime.current < record.stand_up.created_at.at_end_of_day)) || (user.has_role? :admin)
  end

  def destroy?
    ((record.stand_up.user == user) && (DateTime.current < record.stand_up.created_at.at_end_of_day)) || (user.has_role? :admin)
  end

end
