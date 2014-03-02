class AddDateFormatToLocationsMonitorClass < ActiveRecord::Migration
  def change
    add_column :locations_monitor_classes, :date_format, :string
  end
end
