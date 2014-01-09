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

  def as_json(options={})
    super(options).merge({
                             :data => JSON.parse(self.data),
                             :field_log => self.field_log.as_json
                         })
  end
end
