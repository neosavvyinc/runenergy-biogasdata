class AddTwoAdditionalColumnsToMonitorData < ActiveRecord::Migration
  def change
    add_column :flare_monitor_data, :flame_trap_temperature, :decimal, :precision => 10, :scale => 10
    add_column :flare_monitor_data, :flare_run_hours, :decimal, :precision => 10, :scale => 10
  end
end
