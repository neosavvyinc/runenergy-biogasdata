class CreateFlareMonitorData < ActiveRecord::Migration
  def change
    create_table :flare_monitor_data do |t|
      t.datetime :date_time_reading
      t.decimal :inlet_pressure
      t.decimal :blower_speed
      t.decimal :methane
      t.decimal :flame_temperature
      t.decimal :standard_lfg_flow
      t.decimal :standard_cumulative_lfg_volume
      t.decimal :static_pressure
      t.decimal :lfg_temperature
      t.decimal :standard_lfg_volume
      t.decimal :standard_methane_volume

      t.timestamps
    end
  end
end
