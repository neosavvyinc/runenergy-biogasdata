class ReToolCustomMonitorCalculation < ActiveRecord::Migration
  def change
    remove_column :custom_monitor_calculations, :asset_id
    remove_column :custom_monitor_calculations, :monitor_point_id
    add_column :custom_monitor_calculations, :locations_monitor_class_id, :integer
  end
end
