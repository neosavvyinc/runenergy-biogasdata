class RemoveAssetsMonitorClasses < ActiveRecord::Migration
  def change
    drop_table :assets_monitor_classes
  end
end
