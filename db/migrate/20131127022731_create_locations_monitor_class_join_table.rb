class CreateLocationsMonitorClassJoinTable < ActiveRecord::Migration
  def change
    create_table :locations_monitor_classes, :id => false do |t|
      t.integer :location_id
      t.integer :monitor_class_id
    end
  end
end
