class RemoveWorkGroupIdFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :work_group_id, :integer
  end
end
