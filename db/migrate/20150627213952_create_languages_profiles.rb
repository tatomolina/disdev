class CreateLanguagesProfiles < ActiveRecord::Migration
  def change
    create_table :languages_profiles, :id => false do |t|
      t.integer :language_id
      t.integer :profile_id
    end
    add_index(:languages_profiles, [:language_id, :profile_id])
  end
end
