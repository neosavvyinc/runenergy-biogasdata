class AddDeletedColumnCacheToLocationsMonitorClass < ActiveRecord::Migration
  def change
    add_column :locations_monitor_classes, :deleted_column_cache, :string
  end
end
