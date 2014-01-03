require 'csv'

class Reading < DataAsStringModel
  attr_accessible :taken_at, :monitor_class_id, :field_log_id, :location_id, :asset_id
  belongs_to :location
  belongs_to :monitor_class
  belongs_to :field_log
  belongs_to :asset

  def self.process_csv(file)
    unless file.nil?
      readings = []
      CSV.foreach(file.path, headers: true) do |row|
        my_reading = Reading.new_from_csv_row(row)
        unless my_reading.nil?
          readings << my_reading
        end
      end
      readings
    else
      raise 'You cannot pass a blank file to the process_csv method.'
    end
  end

  def self.new_from_csv_row(row)
    unless row.empty?
      data = {}
      row.each do |item|
        data[item[0]] = item[1]
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
