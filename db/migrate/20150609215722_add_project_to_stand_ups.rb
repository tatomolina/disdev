class AddProjectToStandUps < ActiveRecord::Migration
  def change
    add_reference :stand_ups, :project, index: true
  end
end
