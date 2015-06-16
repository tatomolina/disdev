class WorkGroup < ActiveRecord::Base
  #A work_group is a class that represent group of development with all his members
  #has_many :users, :dependent => :nullify
  has_many :memberships, :dependent => :destroy
  has_many :users, :through => :memberships
  has_many :projects, :dependent => :destroy

  has_many :stand_ups, :dependent => :destroy
  validates :name, uniqueness: true

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

end
