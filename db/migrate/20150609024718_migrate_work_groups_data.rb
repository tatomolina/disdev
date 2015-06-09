class MigrateWorkGroupsData < ActiveRecord::Migration
  def up
    ActiveRecord::Base.connection.select_all('select * from USERS').each do |user|
      user_id = user["id"]
      user_work_group =user["work_group_id"]
      Membership.create!(user_id: user_id, work_group_id: user_work_group)
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
