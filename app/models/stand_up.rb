class StandUp < ActiveRecord::Base
  #A standUp represent the colection of tasks a user will do during the day
  #developing and the colection of blockers than he can have 
  belongs_to :user
  has_many :blockers, foreign_key: "stand_up_id", :dependent => :destroy
  has_many :tasks, foreign_key: "stand_up_id", :dependent => :destroy

  accepts_nested_attributes_for :tasks
  accepts_nested_attributes_for :blockers,
  reject_if: proc {|attributes| attributes['title'].blank?},
  reject_if: proc {|attributes| attributes['description'].blank?}

end
