class AddUpperAndLowerToMonitorLimit < ActiveRecord::Migration
  def change
    add_column :monitor_limits, :upper_limit, :decimal, :precision => 10, :scale => 10
    add_column :monitor_limits, :lower_limit, :decimal, :precision => 10, :scale => 10
    remove_column :monitor_limits, :limit
  end
end
