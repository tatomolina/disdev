class StandUp < ActiveRecord::Base

  # Adding this permit to keep track of the object as activitys on the controller
  # to then be displayed as notifications
  include PublicActivity::Common

  # A standUp represent the colection of tasks a user will do during the day
  # developing and the colection of blockers than he can have.
  # A StandUp has only one author and correspond to a determine project.

  belongs_to :user
  belongs_to :project

  # I'm permiting when the standUp is destroyed to automatically destroy their childs
  has_many :blockers, :dependent => :destroy
  has_many :tasks, :dependent => :destroy

  accepts_nested_attributes_for :tasks, :allow_destroy => true

  # A standUp may not have blockers so if they are empty i just dont create them
  accepts_nested_attributes_for :blockers, :allow_destroy => true,
  reject_if: proc {|attributes| attributes['title'].blank?},
  reject_if: proc {|attributes| attributes['description'].blank?}

  private

  def self.looking_yesterday(date, user, project)
    #Search for the last two standUp's
    where("user_id = :user AND created_at <= :stand_date AND project_id = :project",
    {user: user, stand_date: date, project: project})
    .order(created_at: :desc)
    .limit(2)
  end

  def self.next_stand_up(date, user, project)
    #Search for the next two standUp's
    where("user_id = :user AND created_at > :stand_date AND project_id = :project",
    {user: user, stand_date: date, project: project})
    .order(created_at: :asc)
    .limit(1)
  end


end
