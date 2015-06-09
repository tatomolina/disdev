class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.references :work_group, index: true

      t.timestamps
    end
  end
end
