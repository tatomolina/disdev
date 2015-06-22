class User < ActiveRecord::Base

  acts_as_messageable

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

  # Asign an only profile to my user
  has_one :profile, :dependent => :destroy
  after_create :create_profile


  # User can have many standUps
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

  def last_stand_up(project)
    # Return the last standUp from an user in an especific group
    StandUp.all
    .where("user_id = #{self.id} AND project_id = #{project.id}")
    .order(:created_at)
    .last
  end

  def mailboxer_name
    self.username
  end

  def mailboxer_email(object)
    self.email
  end

  def create_profile
    Profile.create(user: self)
  end

end
