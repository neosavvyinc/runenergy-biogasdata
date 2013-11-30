class CreateLocationsUsers < ActiveRecord::Migration
  def change
    create_table :locations_users do |t|
      t.integer :location_id
      t.integer :user_id

      t.timestamps
    end
  end
end
