class StandUp < ActiveRecord::Base
  belongs_to :user
  has_many :blockers, foreign_key: "stand_up_id"
  has_many :tasks, foreign_key: "stand_up_id"
end
