class SwitchIgnoredColumnConversionToBeAttachedToMonitorClass < ActiveRecord::Migration
  def change
    drop_table :column_conversion_mappings_monitor_classes
    remove_column :ignored_column_or_conversions, :columns_conversion_mappings_monitor_class_id
    add_column :ignored_column_or_conversions, :ignored_column_or_conversions_monitor_class_id, :integer
  end
end
