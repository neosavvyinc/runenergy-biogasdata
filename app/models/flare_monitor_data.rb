class FlareMonitorData < ActiveRecord::Base
  attr_accessible :blower_speed, :date_time_reading, :flame_temperature, :inlet_pressure, :lfg_temperature, :methane, :standard_cumulative_lfg_volume, :standard_lfg_flow, :standard_lfg_volume, :standard_methane_volume, :static_pressure
end
