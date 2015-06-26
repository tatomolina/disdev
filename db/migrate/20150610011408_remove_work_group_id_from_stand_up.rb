class RemoveWorkGroupIdFromStandUp < ActiveRecord::Migration
  def change
    remove_column :stand_ups, :work_group_id, :integer
  end
end
