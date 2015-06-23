class StandUp < ActiveRecord::Base
  include PublicActivity::Common

  #A standUp represent the colection of tasks a user will do during the day
  #developing and the colection of blockers than he can have
  belongs_to :user
  belongs_to :project
  has_many :blockers, :dependent => :destroy
  has_many :tasks, :dependent => :destroy

  accepts_nested_attributes_for :tasks, :allow_destroy => true
  accepts_nested_attributes_for :blockers, :allow_destroy => true,
  reject_if: proc {|attributes| attributes['title'].blank?},
  reject_if: proc {|attributes| attributes['description'].blank?}

end
