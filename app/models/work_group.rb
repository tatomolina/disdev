class WorkGroup < ActiveRecord::Base

  resourcify
  #A work_group is a class that represent group of development with all his members
  #has_many :users, :dependent => :nullify
  has_many :memberships, :dependent => :destroy
  has_many :users, :through => :memberships
  has_many :projects, :dependent => :destroy

  has_many :stand_ups, :dependent => :destroy
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
  end

  def remove!(user)
    # Method to leave an especific group
    memberships.find_by("user_id = #{user.id}").destroy
  end

  def remove_roles(user)

    if user.has_role? :owner, self
      user.remove_role :owner, self
    end

    if user.has_role? :general, self
      user.remove_role :general, self
    end

    if user.has_role? :rookie, self
      user.remove_role :rookie, self
    end

    if user.has_role? :n00b, self
      user.remove_role :n00b, self
    end

  end

  def assign_owner
    # If there is a general I assign the owner to the first I encounter
    if User.with_role(:general, self).any?
      users = User.with_role(:general, self)
      users.first.add_role :owner, self
    elsif User.with_role(:rookie, self).any?
      # If ther isnt a general I assign it to the first rookie I found
      users = User.with_role(:rookie, self)
      users.first.add_role :owner
    elsif User.with_role(:n00b, self).any?
      # If ther isnt a rookie I assign it to the first n00b I found
      users = User.with_role(:n00b, self)
      users.first.add_role :owner
    end
  end

end
