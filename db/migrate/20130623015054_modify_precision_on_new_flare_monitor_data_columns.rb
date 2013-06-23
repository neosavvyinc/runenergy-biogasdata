class ModifyPrecisionOnNewFlareMonitorDataColumns < ActiveRecord::Migration
  def change
    change_column :flare_monitor_data, :flame_trap_temperature, :decimal, :precision => 20, :scale => 10
    change_column :flare_monitor_data, :flare_run_hours, :decimal, :precision => 20, :scale => 10
  end
end
