class CreateDeviceProfilesUsers < ActiveRecord::Migration
  def change
    create_table :device_profiles_users, :id => false do |t|
      t.integer :device_profile_id
      t.integer :user_id

      t.timestamps
    end
  end
end
