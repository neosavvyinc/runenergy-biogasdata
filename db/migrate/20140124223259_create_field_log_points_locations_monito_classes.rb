class CreateFieldLogPointsLocationsMonitoClasses < ActiveRecord::Migration
  def change
    create_table :field_log_points_locations_monitor_classes, :id => false do |t|
      t.integer :field_log_point_id
      t.integer :locations_monitor_class_id

      t.timestamps
    end
  end
end
