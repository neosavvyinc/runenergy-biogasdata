class AddDateColumnNameToLocationsMonitorClasss < ActiveRecord::Migration
  def change
    add_column :locations_monitor_classes, :date_column_name, :string
  end
end
