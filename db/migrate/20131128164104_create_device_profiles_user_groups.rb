class CreateDeviceProfilesUserGroups < ActiveRecord::Migration
  def change
    create_table :device_profiles_user_groups, :id => false do |t|
      t.integer :device_profile_id
      t.integer :user_group_id

      t.timestamps
    end
  end
end
