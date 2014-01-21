class ChangeMonitorLimitTypesToStrings < ActiveRecord::Migration
  def change
    change_column :monitor_limits, :lower_limit, :string
    change_column :monitor_limits, :upper_limit, :string
  end
end
