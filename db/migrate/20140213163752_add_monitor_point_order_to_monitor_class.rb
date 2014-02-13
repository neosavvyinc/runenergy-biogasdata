class AddMonitorPointOrderToMonitorClass < ActiveRecord::Migration
  def change
    add_column :monitor_classes, :monitor_point_ordering, :text
  end
end
