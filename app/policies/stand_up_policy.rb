class StandUpPolicy < ApplicationPolicy

  def index?
    record.user == user
  end

  def create?
    record.user == user
  end

  def new?
    user.present?
  end

  def update?
    (record.user == user) && (DateTime.current < record.created_at.at_end_of_day)
  end

  def destroy?
    (record.user == user) && (DateTime.current < record.created_at.at_end_of_day)
  end

end
