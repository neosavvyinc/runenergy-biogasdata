class CreateColumnConversionMappingsMonitorClasses < ActiveRecord::Migration
  def change
    create_table :column_conversion_mappings_monitor_classes do |t|
      t.integer :column_conversion_mapping_id
      t.integer :monitor_class_id

      t.timestamps
    end
  end
end
