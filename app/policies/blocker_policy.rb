class BlockerPolicy < ApplicationPolicy

  def create?
    record.user == user
  end

  def new?
    user.present?
  end

  def update?
    (record.stand_up.user == user) && (DateTime.current < record.stand_up.created_at.at_end_of_day)
  end

  def destroy?
    (record.stand_up.user == user) && (DateTime.current < record.stand_up.created_at.at_end_of_day)
  end

end
