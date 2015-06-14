class User < ActiveRecord::Base

  validates :username,
  :presence => true,
  :uniqueness => {
    :case_sensitive => false
  }

  # Virtual attribute for authenticating by either username or email
  # This is in addition to a real persisted field like 'username'
  attr_accessor :login

  # Class user respresents the users and the members of the workGroups
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :stand_ups, foreign_key: "user_id"

  # Multiple association with work_groups
  has_many :memberships
  has_many :work_groups, :through => :memberships

  # Multiple association with projects
  has_many :project_memberships
  has_many :projects, :through => :project_memberships

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_hash).where("username = :value OR email = :value", { :value => login }).first
    else
      where(conditions.to_hash).first
    end
  end

  def member?(group)
    # Ask if i'm in a especific group
    memberships.find_by("work_group_id = #{group.id}").present?
  end

  def join!(group)
    # Method to join to an especific group
    memberships.create!(work_group: group)
  end

  def leave!(group)
    # Method to leave an especific group
    memberships.find_by("work_group_id = #{group.id}").destroy
  end

  def last_stand_up(project)
    # Return the last standUp from an user in an especific group
    StandUp.all
    .where("user_id = #{self.id} AND project_id = #{project.id}")
    .order(:created_at)
    .last
  end

end
