class Project < ActiveRecord::Base


  # Adding this permit to keep track of the object as activitys on the controller
  # to then be displayed as notifications
  include PublicActivity::Common
  
  # Specify that group is scopped to rolify roles
  resourcify

  validates :name, uniqueness: true, presence: true,
    length: {
      minimum: 1,
      maximum: 20,
      tokenizer: lambda { |str| str.scan(/\w+/) },
      too_short: "Must have at least %{count} words",
      too_long: "Must have at most %{count} words"
    }

  belongs_to :work_group
  has_many :stand_ups, :dependent => :destroy
  #N:M association with users
  has_many :project_memberships, :dependent => :destroy
  has_many :users, :through => :project_memberships

  def member?(user)
    # Ask if i'm in a especific project
    project_memberships.find_by("user_id = #{user.id}").present?
  end

  def add!(user)
    # Method to join to an especific project
    project_memberships.create!(user: user)
    if self.users.count == 1
      user.add_role :manager, self
    else
      user.add_role :developer, self
    end
  end

  def remove!(user)
    # Method to leave an especific project
    project_memberships.find_by("user_id = #{user.id}").destroy
  end

  def remove_roles(user)

    if user.has_role? :manager, self
      user.remove_role :manager, self
    end

    if user.has_role? :scrum_master, self
      user.remove_role :scrum_master, self
    end

    if user.has_role? :developer, self
      user.remove_role :developer, self
    end

    if user.has_role? :product_owner, self
      user.remove_role :product_owner, self
    end

  end

  def assign_manager
    # If there is a scrum master I assign the manager to the first I encounter
    if User.with_role(:scrum_master, self).any?
      users = User.with_role(:scrum_master, self)
      users.first.add_role :manager, self
    elsif User.with_role(:developer, self).any?
      # If ther isnt a scrum master I assign it to the first developer I found
      users = User.with_role(:developer, self)
      users.first.add_role :manager
    elsif User.with_role(:product_owner, self).any?
      # If ther isnt a scrum master I assign it to the first developer I found
      users = User.with_role(:product_owner, self)
      users.first.add_role :manager
    end
  end

end
