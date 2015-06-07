class CreateMemberships < ActiveRecord::Migration
  def change
    create_table(:memberships, :id => false) do |t|
      t.references :user, index: true
      t.references :work_group, index: true

      t.timestamps
    end
    add_index(:memberships, [:user_id, :work_group_id], :unique => true)
  end
end
