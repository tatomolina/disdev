class CreateProfiles < ActiveRecord::Migration
  def up
    create_table :profiles do |t|
      t.string :first_name
      t.string :last_name
      t.date :date_of_birth
      t.references :user, index: true

      t.timestamps
    end
    User.find_each do |user|
      Profile.create!(user: user)
    end
  end
  def down
    drop_table :profiles
  end
end
