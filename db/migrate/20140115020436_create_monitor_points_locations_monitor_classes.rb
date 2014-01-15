class CreateMonitorPointsLocationsMonitorClasses < ActiveRecord::Migration
  def change
    create_table :monitor_points_locations_monitor_classes do |t|
      t.integer :monitor_point_id
      t.integer :locations_monitor_class_id

      t.timestamps
    end
  end
end
