class AddStandUpToTasks < ActiveRecord::Migration
  def change
    add_reference :tasks, :stand_up, index: true
  end
end
