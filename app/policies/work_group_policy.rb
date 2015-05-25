class WorkGroupPolicy < ApplicationPolicy

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
    user.has_role? :admin
  end

  def destroy?
    user.has_role? :admin
  end

end
