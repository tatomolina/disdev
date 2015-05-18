class AddStandUpToBlockers < ActiveRecord::Migration
  def change
    add_reference :blockers, :stand_up, index: true
  end
end
