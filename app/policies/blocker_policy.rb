class BlockerPolicy < ApplicationPolicy

  def show?
    # Permit only if the user is member of the project wich the blocker belongs to
    user.present? && ((record.stand_up.project.member? user) || (user.has_role? :admin))
  end

  def edit?
    user.present? && (((record.stand_up.user == user) && (DateTime.current < record.stand_up.created_at.at_end_of_day)) || (user.has_role? :admin))
  end

  def update?
    user.present? && (((record.stand_up.user == user) && (DateTime.current < record.stand_up.created_at.at_end_of_day)) || (user.has_role? :admin))
  end

  def destroy?
    user.present? && (((record.stand_up.user == user) && (DateTime.current < record.stand_up.created_at.at_end_of_day)) || (user.has_role? :admin))
  end

end
