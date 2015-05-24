class WorkGroup < ActiveRecord::Base
  has_many :users, foreign_key: "work_group_id"
end
