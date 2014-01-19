class ChangeColumnsLenghtsForDataColumns < ActiveRecord::Migration
  def change
    change_column :readings, :data, :string, :limit => 8000
    change_column :locations_monitor_classes, :column_cache, :string, :limit => 8000
    change_column :locations_monitor_classes, :deleted_column_cache, :string, :limit => 8000
  end
end
