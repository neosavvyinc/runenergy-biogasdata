class RemoveUnnecessaryIdsFromIgnoredColumnsOrConversions < ActiveRecord::Migration
  def change
    remove_column :ignored_column_or_conversions, :ignored_column_or_conversions_monitor_class_id
  end
end
