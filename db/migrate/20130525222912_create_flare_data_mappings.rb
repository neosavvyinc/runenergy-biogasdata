class CreateFlareDataMappings < ActiveRecord::Migration
  def change
    create_table :flare_data_mappings do |t|
      t.integer :date_reading_column
      t.integer :time_reading_column
      t.integer :inlet_pressure_column
      t.integer :blower_speed_column
      t.integer :methane_column
      t.integer :flame_temperature_column
      t.integer :static_pressure_column
      t.integer :lfg_temperature_column
      t.integer :standard_methane_volume_column
      t.integer :standard_lfg_flow_column
      t.integer :standard_lfg_volume_column
      t.integer :standard_cumulative_lfg_volume_column

      t.timestamps
    end
  end
end
