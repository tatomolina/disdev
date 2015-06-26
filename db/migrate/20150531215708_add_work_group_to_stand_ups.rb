class AddWorkGroupToStandUps < ActiveRecord::Migration
  def change
    add_reference :stand_ups, :work_group, index: true
  end
end
