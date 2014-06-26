class CreateIgnoredColumnOrConversions < ActiveRecord::Migration
  def change
    create_table :ignored_column_or_conversions do |t|
      t.boolean :ignore
      t.string :convert_to
      t.integer :columns_conversion_mappings_monitor_class_id

      t.timestamps
    end
  end
end
