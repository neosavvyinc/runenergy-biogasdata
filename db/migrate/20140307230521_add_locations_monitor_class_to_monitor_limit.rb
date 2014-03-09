class AddLocationsMonitorClassToMonitorLimit < ActiveRecord::Migration
  def change
    add_column :monitor_limits, :locations_monitor_class_id, :integer
    remove_column :monitor_limits, :location_id
  end
end
