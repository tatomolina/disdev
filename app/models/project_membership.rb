class ProjectMembership < ActiveRecord::Base
  # Set the primary keys
  self.primary_keys = :user_id, :project_id

  belongs_to :user
  belongs_to :project
end
