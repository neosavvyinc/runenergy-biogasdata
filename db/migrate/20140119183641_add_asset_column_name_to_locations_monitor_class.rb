class AddAssetColumnNameToLocationsMonitorClass < ActiveRecord::Migration
  def change
    add_column :locations_monitor_classes, :asset_column_name, :string
  end
end
