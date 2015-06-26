class Membership < ActiveRecord::Base
  # Set the primary keys
  self.primary_keys = :user_id, :work_group_id

  belongs_to :user
  belongs_to :work_group

  #validates :user_id, presence: true
  #validates :work_group_id, presence: true
end
