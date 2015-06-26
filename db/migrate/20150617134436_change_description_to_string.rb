class ChangeDescriptionToString < ActiveRecord::Migration
  def up
    change_column :tasks, :description, :string
  end
  def down
    change_column :tasks, :description, :text
  end
end
