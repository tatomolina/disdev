class AddWorkGroupToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :work_group, index: true
  end
end
