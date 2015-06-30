class WorkGroup < ActiveRecord::Base
  # A work_group is a class that represent group of development with all his members

  # Specify that group is scopped to rolify roles
  resourcify

  # Specify N:M relationship with users
  has_many :memberships, :dependent => :destroy
  has_many :users, :through => :memberships

  # A group can have many projects associated
  has_many :projects, :dependent => :destroy

  validates :name, uniqueness: true, presence: true,
    length: {
      minimum: 1,
      maximum: 20,
      tokenizer: lambda { |str| str.scan(/\w+/) },
      too_short: "Must have at least %{count} words",
      too_long: "Must have at most %{count} words"
    }

  # It returns the articles whose titles contain one or more words that form the query
  def self.search(search)
    # where(:title, query) -> This would return an exact match of the query
    if search
      where("name LIKE ?", "%#{search}%")
    else
      all.limit(10).order(created_at: :desc)
    end
  end

  def member?(user)
    # Ask if i'm in a especific group
    memberships.find_by("user_id = #{user.id}").present?
  end

  def add!(user)
    # Method to join to an especific group
    memberships.create!(user: user)
    if self.users.count == 1
      user.add_role :owner, self
    end
    user.add_role :member, self
  end

  def remove!(user)
    # Method to leave an especific group
    memberships.find_by("user_id = #{user.id}").destroy
  end

  def remove_roles(user)

    if user.has_role? :owner, self
      user.remove_role :owner, self
    end

    if user.has_role? :member, self
      user.remove_role :member, self
    end

  end

  def assign_owner
    # If there is a general I assign the owner to the first I encounter
    if User.with_role(:member, self).any?
      users = User.with_role(:member, self)
      users.first.add_role :owner, self
    end
  end

end
