require 'csv'

class Reading < DataAsStringModel
  attr_accessible :taken_at, :monitor_class_id, :field_log_id, :location_id, :asset_id
  belongs_to :location
  belongs_to :monitor_class
  belongs_to :field_log
  belongs_to :asset

  def self.process_csv(file, column_definition_row = nil, first_data_row = nil, last_data_row = nil)
    unless file.nil?
      readings = []

      #Starts at 1 for human readable form in the UI
      idx = 1
      header = nil
      column_definition_row = column_definition_row || 1
      first_data_row = first_data_row || 2
      CSV.foreach(file.path) do |row|
        #Sets the header from within the CSV
        if idx == column_definition_row
          header = row
        elsif not header.nil? and idx >= first_data_row and (last_data_row.nil? or idx <= last_data_row)
          my_reading = Reading.new_from_csv_row(header, row)
          unless my_reading.nil?
            readings << my_reading
          end
        end

        #Increment the idx
        idx += 1
      end
      readings
    else
      raise 'You cannot pass a blank file to the process_csv method.'
    end
  end

  def self.new_from_csv_row(header, row)
    unless header.empty? or row.empty?
      data = {}
      header.each_with_index do |item, index|
        unless header[index].blank?
          data[header[index]] = row[index]
        end
      end
      Reading.new(:data => data.to_json)
    end
  end

  def self.process_edited_collection(readings, column_to_monitor_point_mappings, deleted_columns, deleted_row_indices, site_id, monitor_class_id, asset_id)
    unless readings.nil?
      new_readings = []
      column_to_name_cache = {}
      readings.each_with_index do |data, index|
        #Index +1 for user readability
        unless (not deleted_row_indices.nil? and deleted_row_indices.include?(index + 1))
          new_readings << Reading.create(
              :location_id => site_id,
              :monitor_class_id => monitor_class_id,
              :asset_id => asset_id,
              :data => self.map_and_validate_columns(data, column_to_monitor_point_mappings, deleted_columns, column_to_name_cache)
          )
        end
      end
      new_readings
    else
      raise 'You must pass in a collection of readings to process readings.'
    end
  end

  def self.map_and_validate_columns(reading, column_to_point_id, deleted_columns, column_to_name_cache)
    new_reading = {}
    reading.each do |column, value|
      if deleted_columns[column].nil?
        unless column_to_point_id[column].blank?
          if column_to_name_cache[column].blank?
            column_to_name_cache[column] = MonitorPoint.find(column_to_point_id[column]['id'].to_i).try(:name)
          end
          new_reading[column_to_name_cache[column]] = value
        end
      end
    end
    new_reading
  end

  def as_json(options={})
    super(options).merge({
                             :data => JSON.parse(self.data),
                             :field_log => self.field_log.as_json
                         })
  end
end
