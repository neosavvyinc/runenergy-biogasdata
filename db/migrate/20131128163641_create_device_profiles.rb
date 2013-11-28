class CreateDeviceProfiles < ActiveRecord::Migration
  def change
    create_table :device_profiles do |t|
      t.string :uid
      t.string :name

      t.timestamps
    end
  end
end
