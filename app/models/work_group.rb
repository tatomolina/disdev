class WorkGroup < ActiveRecord::Base
  #A work_group is a class that represent group of development with all his members
  has_many :users, foreign_key: "work_group_id"
end
