class FlareMonitorData < ActiveRecord::Base
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations
  include SmartInitialization
  include SmartAssignment

  attr_accessible :blower_speed, :date_time_reading, :flame_temperature, :inlet_pressure, :lfg_temperature, :methane, :standard_cumulative_lfg_volume, :standard_lfg_flow, :standard_lfg_volume, :standard_methane_volume, :static_pressure, :flare_specification_id
  belongs_to :flare_specification

  DATE = "date"
  TIME = "time"
  DEFAULT_ROW_MAPPING = {
      "blower_speed_hz" => :blower_speed,
      "vacuum_kpa" => :inlet_pressure,
      "methane_lvl_pcnt" => :methane,
      "flame_temp_degc" => :flame_temperature,
      "gas_inst_flow" => :standard_lfg_flow,
      "gas_total_flow" => :standard_cumulative_lfg_volume,
      "gas_static_press" => :static_pressure,
      "gas_temp" => :lfg_temperature,
      "gas_flow_mtd_m3" => :standard_lfg_volume,
      "ch4_flow_mtd_m3" => :standard_methane_volume
  }

  #@TODO, should pass in a flare or mapping in order to determine how this is mapped
  def self.import(file_path, flare_specification=nil)
    unless flare_specification.blank?
      idx = 0
      header = nil
      CSV.foreach(file_path) do |row|
        if idx == 0
          header = row.map { |column| column.downcase.strip.gsub(/\s+/, "_") }
        else
          row = [header, row].transpose
          row = Hash[row.map { |key_then_value|
            if key_then_value.first == DATE or key_then_value.first == TIME
              key_then_value
            else
              [DEFAULT_ROW_MAPPING[key_then_value[0]], key_then_value[1]]
            end
          }]
          flare_monitor_data = new_ignore_unknown(row)
          flare_monitor_data.date_time_reading = Date.strptime((row['date'] + " " + row["time"]), "%d/%m/%y %l:%M%S")
          flare_monitor_data.flare_specification = flare_specification
          flare_monitor_data.save!
        end
        idx += 1
      end
    else
      raise "You must specify a flare_specification in order to import Flare Monitor Data from a CSV"
    end
  end

  def self.display_name_for_field(field)
    AttributeNameMapping.find_by_attribute_name(field.to_s).try(:display_name) || ""
  end

end
