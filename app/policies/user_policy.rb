class UserPolicy < ApplicationPolicy

  def show?
    super
  end

  def show_projects?
    user.present?
  end

  def show_messages?
    user.present? && record == user
  end
end
