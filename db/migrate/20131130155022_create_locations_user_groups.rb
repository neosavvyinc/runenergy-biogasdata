class CreateLocationsUserGroups < ActiveRecord::Migration
  def change
    create_table :locations_user_groups do |t|
      t.integer :location_id
      t.integer :user_group_id

      t.timestamps
    end
  end
end
