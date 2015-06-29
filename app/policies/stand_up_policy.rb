class StandUpPolicy < ApplicationPolicy

  def create?
    (user.present?) && ((record.project.member? user) || (user.has_role? :admin))
  end

  def new?
    (user.present?) && ((user.projects.present?) || (user.has_role? :admin))
  end

  def update?
    user.present? && (((record.user == user) && (DateTime.current < record.created_at.at_end_of_day)) || (user.has_role? :admin))
  end

  def destroy?
    user.present? && (((record.user == user) && (DateTime.current < record.created_at.at_end_of_day)) || (user.has_role? :admin))
  end

end
