class AddUserToStandUps < ActiveRecord::Migration
  def change
    add_reference :stand_ups, :user, index: true
  end
end
