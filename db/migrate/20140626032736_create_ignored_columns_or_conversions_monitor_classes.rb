class CreateIgnoredColumnsOrConversionsMonitorClasses < ActiveRecord::Migration
  def change
    create_table :ignored_columns_or_conversions_monitor_classes do |t|
      t.integer :ignored_column_or_conversion
      t.integer :monitor_class_id

      t.timestamps
    end
  end
end
