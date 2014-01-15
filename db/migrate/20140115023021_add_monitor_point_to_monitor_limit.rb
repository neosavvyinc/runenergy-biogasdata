class AddMonitorPointToMonitorLimit < ActiveRecord::Migration
  def change
    add_column :monitor_limits, :monitor_point_id, :integer
  end
end
