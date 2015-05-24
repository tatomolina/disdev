class StandUp < ActiveRecord::Base
  belongs_to :user
  has_many :blockers, foreign_key: "stand_up_id", :dependent => :destroy
  has_many :tasks, foreign_key: "stand_up_id", :dependent => :destroy

  accepts_nested_attributes_for :tasks
  accepts_nested_attributes_for :blockers,
  reject_if: proc {|attributes| attributes['title'].blank?},
  reject_if: proc {|attributes| attributes['description'].blank?}

end
