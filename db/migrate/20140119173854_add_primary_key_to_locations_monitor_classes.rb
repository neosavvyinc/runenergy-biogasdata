class AddPrimaryKeyToLocationsMonitorClasses < ActiveRecord::Migration
  def change
    add_column :locations_monitor_classes, :id, :primary_key
  end
end
