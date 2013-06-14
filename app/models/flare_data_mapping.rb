class FlareDataMapping < ActiveRecord::Base
  attr_accessible :name, :blower_speed_column, :flame_temperature_column, :inlet_pressure_column, :lfg_temperature_column, :methane_column, :standard_cumulative_lfg_volume_column, :standard_lfg_flow_column, :standard_lfg_volume_column, :standard_methane_volume_column, :static_pressure_column
  validates_presence_of (self.column_names - ["id"])
  before_save :sanitize_values

  def sanitize_values
    attributes.each do |key, value|
      unless value.blank? or key.to_s == 'name'
        self[key] = value.to_s.downcase.strip.gsub(/\s+/, "_")
      end
    end
  end

  def values_to_attributes
    hash = as_json
    new_hash = {}
    hash.each do |key, value|
      unless value.blank? or [:id, :name, :updated_at, :created_at].include?(key.to_sym)
        new_hash[value] = key.sub("_column", "").to_sym
      end
    end
    new_hash
  end
end
