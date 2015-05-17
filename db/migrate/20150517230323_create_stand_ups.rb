class CreateStandUps < ActiveRecord::Migration
  def change
    create_table :stand_ups do |t|

      t.timestamps
    end
  end
end
