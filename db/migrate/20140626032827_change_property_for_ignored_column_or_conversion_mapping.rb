class ChangePropertyForIgnoredColumnOrConversionMapping < ActiveRecord::Migration
  def change
    remove_column :ignored_columns_or_conversions_monitor_classes, :ignored_column_or_conversion
    add_column :ignored_columns_or_conversions_monitor_classes, :ignored_column_or_conversion_id, :integer
  end
end
