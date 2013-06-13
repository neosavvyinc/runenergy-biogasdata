class SwitchColumnsToStrings < ActiveRecord::Migration
  def change
    change_column :flare_data_mappings, :blower_speed_column, :string
    change_column :flare_data_mappings, :date_reading_column, :string
    change_column :flare_data_mappings, :flame_temperature_column, :string
    change_column :flare_data_mappings, :inlet_pressure_column, :string
    change_column :flare_data_mappings, :lfg_temperature_column, :string
    change_column :flare_data_mappings, :methane_column, :string
    change_column :flare_data_mappings, :standard_cumulative_lfg_volume_column, :string
    change_column :flare_data_mappings, :standard_lfg_flow_column, :string
    change_column :flare_data_mappings, :standard_methane_volume_column, :string
    change_column :flare_data_mappings, :static_pressure_column, :string
    change_column :flare_data_mappings, :time_reading_column, :string
  end
end
