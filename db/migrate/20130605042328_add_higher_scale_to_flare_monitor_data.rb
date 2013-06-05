class AddHigherScaleToFlareMonitorData < ActiveRecord::Migration
  def change
    change_column :flare_monitor_data, :inlet_pressure, :decimal, :precision => 20, :scale => 10
    change_column :flare_monitor_data, :blower_speed, :decimal, :precision => 20, :scale => 10
    change_column :flare_monitor_data, :methane, :decimal, :precision => 20, :scale => 10
    change_column :flare_monitor_data, :flame_temperature, :decimal, :precision => 20, :scale => 10
    change_column :flare_monitor_data, :standard_lfg_flow, :decimal, :precision => 20, :scale => 10
    change_column :flare_monitor_data, :standard_cumulative_lfg_volume, :decimal, :precision => 20, :scale => 10
    change_column :flare_monitor_data, :static_pressure, :decimal, :precision => 20, :scale => 10
    change_column :flare_monitor_data, :lfg_temperature, :decimal, :precision => 20, :scale => 10
    change_column :flare_monitor_data, :standard_lfg_volume, :decimal, :precision => 20, :scale => 10
    change_column :flare_monitor_data, :standard_methane_volume, :decimal, :precision => 20, :scale => 10
  end
end
