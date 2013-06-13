class FlareDataMapping < ActiveRecord::Base
  attr_accessible :name, :blower_speed_column, :date_reading_column, :flame_temperature_column, :inlet_pressure_column, :lfg_temperature_column, :methane_column, :standard_cumulative_lfg_volume_column, :standard_lfg_flow_column, :standard_lfg_volume_column, :standard_methane_volume_column, :static_pressure_column, :time_reading_column
  validates_presence_of :name
  before_save :sanitize_values

  def sanitize_values
    attributes.each do |key, value|
      unless value.blank? or key.to_s == 'name'
        self[key] = value.to_s.downcase.strip.gsub(/\s+/, "_")
      end
    end
  end
end
