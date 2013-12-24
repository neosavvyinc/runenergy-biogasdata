class AddMonitorClassIdToAsset < ActiveRecord::Migration
  def change
    add_column :assets, :monitor_class_id, :integer
  end
end
