class AnswerPolicy < ApplicationPolicy

  def create?
    (user.present?) && ((record.blocker.stand_up.project.member? user) || (user.has_role? :admin))
  end

  def destroy?
    (record.user == user) || (user.has_role? :admin)
  end
end
