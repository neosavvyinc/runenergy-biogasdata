class FlareMonitorData < ActiveRecord::Base
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations
  include SmartInitialization
  include SmartAssignment

  attr_accessible :blower_speed, :date_time_reading, :flame_temperature, :inlet_pressure, :lfg_temperature, :methane, :standard_cumulative_lfg_volume, :standard_lfg_flow, :standard_lfg_volume, :standard_methane_volume, :static_pressure, :flame_trap_temperature, :flare_run_hours, :flare_specification_id
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
      "ch4_flow_mtd_m3" => :standard_methane_volume,
      "flame_trap_temp" => :flame_trap_temperature,
      "flare_run_hr" => :flare_run_hours
  }

  @@column_weights = {}
  @@significant_digits = {}

  #@TODO, should pass in a flare or mapping in order to determine how this is mapped
  def self.import(file_path, flare_specification=nil)
    unless flare_specification.blank?
      idx = 0
      header = nil
      custom_mapping = flare_specification.flare_data_mapping.try(:values_to_attributes)
      CSV.foreach(file_path) do |row|
        if idx == 0
          header = row.map { |column| column.downcase.strip.gsub(/\s+/, "_") }
        else
          row = [header, row].transpose
          row = Hash[row.map { |key_then_value|
            if key_then_value.first == DATE or key_then_value.first == TIME
              key_then_value
            elsif not custom_mapping.nil?
              [custom_mapping[key_then_value[0]], key_then_value[1]]
            else
              [DEFAULT_ROW_MAPPING[key_then_value[0]], key_then_value[1]]
            end
          }]
          flare_monitor_data = new_ignore_unknown(row)
          date_with_zeroes = row['date'].gsub(/-/, "/").split("/").map { |p| (p.to_s.length == 1) ? "0" + p.to_s : p.to_s }.join("/")
          time_with_zeroes = row['time'].split(":").map { |p| (p.to_s.length == 1) ? "0" + p.to_s : p.to_s }.join(":")
          flare_monitor_data.date_time_reading = Time.strptime((date_with_zeroes + time_with_zeroes), "%d/%m/%y%H:%M:%S")
          flare_monitor_data.flare_specification = flare_specification
          flare_monitor_data.save!
        end
        idx += 1
      end
    else
      raise "You must specify a flare_specification in order to import Flare Monitor Data from a CSV"
    end
  end

  def self.display_object_for_field(field)
    AttributeNameMapping.find_by_attribute_name(field.to_s) or {}
  end

  def self.column_weight_for_field(field)
    if @@column_weights[field.to_sym].nil?
      @@column_weights[field.to_sym] = FlareMonitorData.display_object_for_field(field)[:column_weight]
    end
    @@column_weights[field.to_sym]
  end

  def self.significant_digits_for_field(field)
    if @@significant_digits[field.to_sym].nil?
      @@significant_digits[field.to_sym] = FlareMonitorData.display_object_for_field(field)[:significant_digits]
    end
    @@significant_digits[field.to_sym]
  end

  def self.filter_data(options, initial_relation = self.scoped)
    options.inject(initial_relation) do |current_scope, (key, value)|
      next current_scope if value.blank?
      case key
        when 'flareSpecificationId'
          current_scope.where(:flare_specification_id => options['flareSpecificationId']).order("date_time_reading DESC")
        else #unknown key
          current_scope
      end
    end
  end

  def self.to_csv(flare_monitor_data, exceptions = [])
    CSV.generate do |csv|
      #remove exception cols
      csv_cols = column_names.delete_if { |col| exceptions.map(&:to_s).include?(col) }.
          sort_by { |col| (FlareMonitorData.column_weight_for_field(col) or 0) }
      #convert col names to human
      header_cols = csv_cols.map {
          |col|
        display = display_object_for_field(col)
        unless display.units.blank?
          "#{display.try(:display_name)} (#{display.try(:units)})"
        else
          display.try(:display_name)
        end
      }
      csv << header_cols
      flare_monitor_data.each do |flare_monitor_datum|
        csv << flare_monitor_datum.as_json_significant_digits.values_at(*csv_cols)
      end
    end
  end

  #@TODO, slight refactor here
  def self.date_range(user_type, flare_deployment, flare_speicification_id, start_date, end_date, start_time, end_time)
    query = filter_data({'flareSpecificationId' => flare_speicification_id})
    date_time = nil
    if not start_date.blank?
      unless start_time.blank?
        date_time = DateTime.strptime(start_date + start_time, "%d/%m/%Y%H:%M:%S")
      else
        date_time = DateTime.strptime(start_date, "%d/%m/%Y")
      end
    end

    if user_type == UserType.OVERSEER
      min_date = date_time
    else
      min_date = flare_deployment.min_date(date_time)
    end

    unless min_date.blank?
      query = query.where('date_time_reading >= ?', min_date)
    end

    date_time = nil
    if not end_date.blank?
      unless end_time.blank?
        date_time = DateTime.strptime(end_date + end_time, "%d/%m/%Y%H:%M:%S")
      else
        date_time = DateTime.strptime(end_date, "%d/%m/%Y")
      end
    end

    if user_type == UserType.OVERSEER
      max_date = date_time
    else
      max_date = flare_deployment.max_date(date_time)
    end

    unless max_date.blank?
      query = query.where('date_time_reading <= ?', max_date)
    end

    query
  end

  #@TODO, add some SQL injection protection. Check for regex
  def self.with_filters(query, attributes_to_filters=nil)
    unless attributes_to_filters.nil? or attributes_to_filters.empty?
      builder = FlareMonitorDataQueryBuilder.new(query)
      attributes_to_filters.each do |attr, filter|
        unless filter.blank?
          builder.where_filter(attr, filter)
        end
      end
      builder.query
    else
      query
    end
  end

  #Calculations
  NET_HEATING_VALUE = 0.0339
  METHANE_NHV_VALUE = 50
  METHANE_GWP = 21

  def energy
    NET_HEATING_VALUE * (methane || 0)
  end

  def methane_tonne
    ((energy || 0) / METHANE_NHV_VALUE)
  end

  def as_json(options=nil)
    hash = super
    #Flare Specification Fields
    hash['flare_specification_id'] = self.flare_specification.try(:flare_unique_identifier)
    #Formatting
    hash['date_time_reading'] = self.date_time_reading.try(:strftime, "%d/%m/%Y %H:%M:%S")
    hash
  end

  def as_json_significant_digits (options=nil)
    hash = as_json(options)
    hash.each do |key, value|
      unless value.to_s.nan?
        significant_digits = FlareMonitorData.significant_digits_for_field(key)
        unless significant_digits.nil?
          power = (10 ** significant_digits)
          hash[key] = ((value.to_f * power).round.to_f / power)
        end
      end
    end
    hash
  end

  def as_json_from_keys(keys, options=nil)
    as_json(options).values_at(*keys)
  end
end
