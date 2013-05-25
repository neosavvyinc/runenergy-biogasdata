class FlareDataMapping < ActiveRecord::Base
  attr_accessible :blower_speed_column, :date_reading_column, :flame_temperature_column, :inlet_pressure_column, :lfg_temperature_column, :methane_column, :standard_cumulative_lfg_volume_column, :standard_lfg_flow_column, :standard_lfg_volume_column, :standard_methane_volume_column, :static_pressure_column, :time_reading_column
end
