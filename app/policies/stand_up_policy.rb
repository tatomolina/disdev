class StandUpPolicy < ApplicationPolicy

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
    ((record.user == user) && (DateTime.current < record.created_at.at_end_of_day)) || (user.has_role? :admin)
  end

  def destroy?
    ((record.user == user) && (DateTime.current < record.created_at.at_end_of_day)) || (user.has_role? :admin)
  end

end
