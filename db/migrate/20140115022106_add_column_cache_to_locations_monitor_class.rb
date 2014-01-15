class AddColumnCacheToLocationsMonitorClass < ActiveRecord::Migration
  def change
    add_column :locations_monitor_classes, :column_cache, :string
  end
end
