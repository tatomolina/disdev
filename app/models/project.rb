class Project < ActiveRecord::Base
  belongs_to :work_group
  #has_many :stand_ups, :dependent => :destroy
  has_many :project_memberships, :dependent => :destroy
  has_many :users, :through => :project_memberships

  def member?(user)
    # Ask if i'm in a especific project
    project_memberships.find_by("user_id = #{user.id}").present?
  end

  def add!(user)
    # Method to join to an especific project
    project_memberships.create!(user: user)
  end

  def remove!(user)
    # Method to leave an especific project
    project_memberships.find_by("user_id = #{user.id}").destroy
  end
end
