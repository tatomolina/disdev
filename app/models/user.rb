class User < ActiveRecord::Base
  # Class user respresents the users and the members of the workGroups
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :stand_ups, foreign_key: "user_id"

  # Multiple association with groups
  has_many :memberships
  has_many :work_groups, :through => :memberships

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

  def last_stand_up(group)
    # Return the last standUp from an user in an especific group
    StandUp.all
    .where("user_id = #{self.id} AND work_group_id = #{group.id}")
    .order(:created_at)
    .last
  end

end
