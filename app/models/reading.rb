require 'csv'

class Reading < DataAsStringModel
  attr_accessible :taken_at, :monitor_class_id, :field_log_id, :location_id, :asset_id, :data_collision_id
  belongs_to :location
  belongs_to :monitor_class
  belongs_to :field_log
  belongs_to :asset
  belongs_to :data_collision

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
      Reading.create(:data => data.to_json)
    end
  end

  def self.process_edited_collection(readings, column_to_monitor_point_mappings, deleted_columns, deleted_row_indices, site_id, monitor_class_id, asset_column_name, reading_date = nil, date_column_name = nil, date_format = nil)
    unless readings.nil? or site_id.blank? or monitor_class_id.blank? or asset_column_name.blank?
      new_readings = []
      column_to_name_cache = {}
      readings.each_with_index do |data, index|
        #Index +1 for user readability
        unless (not deleted_row_indices.nil? and deleted_row_indices.include?(index + 1))

          #Lazy load assets into db based on site_id and column value
          asset = Asset.lazy_load(site_id, monitor_class_id, data[asset_column_name])
          asset.monitor_class = MonitorClass.find(monitor_class_id)
          asset.save

          #Asset Ids can be duplicated over the course of various sites
          new_readings << Reading.create(
              :location_id => site_id,
              :monitor_class_id => monitor_class_id,
              :asset_id => asset.id,
              :taken_at => self.choose_reading_date(data, reading_date, date_column_name, date_format),
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
          new_reading[column_to_name_cache[column]] = value.to_s.strip.gsub(',', '')
        end
      end
    end
    new_reading
  end

  def self.choose_reading_date(data, reading_date, date_column_name, date_format = nil)
    unless date_column_name.nil?
      unless data[date_column_name].blank?
        begin
          DateTime.strptime(data[date_column_name], (date_format || '%d-%b-%y')).utc
        rescue
          raise Exceptions::InvalidDateFormatException
        end
      else
        nil
      end
    else
      reading_date
    end
  end

  def self.export_csv(options = {}, section_id = nil, start_date = nil, end_date = nil, filters = nil)
    CSV.generate do |csv|
      readings = apply_section_filter(apply_end_date(apply_start_date(Reading.where(options), start_date), end_date), section_id)
      #Date Time Filters For Readings
      if readings.size > 0
        #Get the locations_monitor_class as it pertains to the first reading
        locations_monitor_class = LocationsMonitorClass.lazy_load(readings.first.location_id, readings.first.monitor_class.id)

        #Get the correct ordering group
        monitor_point_ordering = readings.first.try(:monitor_class).try(:grouped_monitor_point_ordering)

        #Get the parsed version of the firsts data
        first_data = readings.first.add_calculations_as_json(locations_monitor_class)[:data]

        #Arrange the header with the added pieces
        header = ['Asset', 'Date Time'].concat(first_data.map { |k, v| k })
        header = header.sort_by { |n| (monitor_point_ordering.nil? or monitor_point_ordering[n].nil? ? header.size : monitor_point_ordering[n]) }
        csv << header

        #Reading rows
        date_asset_less_header = header.reject { |c| c == 'Asset' or c == 'Date Time' }
        readings.each do |reading|
          row = reading.add_calculations_as_json(locations_monitor_class)[:data].values_at(*date_asset_less_header)
          row.insert(monitor_point_ordering['Asset'], reading.try(:asset).try(:unique_identifier) || '')
          row.insert(monitor_point_ordering['Date Time'], reading.try(:taken_at).try(:strftime, '%d/%m/%Y, %H:%M:%S') || '')
          csv << row
        end
      end
    end
  end

  def self.apply_start_date(readings, start_date)
    if start_date.nil?
      readings
    else
      readings.where('taken_at >= ?', start_date)
    end
  end

  def self.apply_end_date(readings, end_date)
    if end_date.nil?
      readings
    else
      readings.where('taken_at <= ?', end_date)
    end
  end

  def self.apply_section_filter(readings, section_id)
    if section_id.nil?
      readings
    else
      assets = Asset.where(:section_id => section_id).group_by {|a| a.id.to_s}
      readings.reject {|r| assets[r.asset_id.to_s].nil?}
    end
  end

  def taken_at_epoch
    taken_at.try(:to_f)
  end

  def previous_readings_for_indices(indices)
    pr = {}
    unless indices.nil? or not indices.size
      indices.each do |i|
        data = self.previous_reading(i.to_i.abs).try(:data)
        if data
          pr[i] = JSON.parse(data)
        else
          pr[i] = nil
        end
      end
    end
    pr
  end

  def previous_reading(backwards = 1)
    readings = nil
    if not self.taken_at.nil?
      readings = Reading.where('asset_id = ? and taken_at <= ?', self.asset_id, self.taken_at).order('taken_at DESC')
    elsif not self.created_at.nil?
      readings = Reading.where('asset_id = ? and created_at <= ?', self.asset_id, self.created_at).order('created_at DESC')
    end

    if readings and readings.size and readings.size > backwards
      readings[backwards]
    else
      nil
    end
  end

  def mark_limits_as_json(locations_monitor_class_id, monitor_limit_cache=nil)
    val = as_json
    unless locations_monitor_class_id.nil? or self.data.nil?
      val[:data].each do |k, v|
        ml = nil
        if monitor_limit_cache and monitor_limit_cache[k]
          ml = monitor_limit_cache[k]
        else
          ml = MonitorPoint.find_by_name(k).try(:monitor_limit_for_locations_monitor_class, locations_monitor_class_id).try(:as_json)
          if ml and monitor_limit_cache
            monitor_limit_cache[k] = ml
          end
        end
        if ml
          if v.blank?
            val[:lower_limits] ||= []
            val[:lower_limits] << k
          elsif v.to_s.numeric?
            if v.to_f > ml['upper_limit'].to_f
              val[:upper_limits] ||= []
              val[:upper_limits] << k
            elsif v.to_f < ml['lower_limit'].to_f
              val[:lower_limits] ||= []
              val[:lower_limits] << k
            end
          end
        end
      end
    end
    val
  end

  def add_calculations_as_json(locations_monitor_class)
    val = as_json
    if locations_monitor_class and
        locations_monitor_class.custom_monitor_calculations
      locations_monitor_class.custom_monitor_calculations.each do |cmc|
        val[:data][cmc.name] = cmc.parse(
            asset,
            val[:data],
            cmc.requires_previous_reading? ? previous_reading.try(:data) : nil,
            cmc.requires_quantified_previous_reading? ? previous_readings_for_indices(cmc.previous_data_indices) : nil,
            cmc.requires_date_interval? ? self.taken_at : nil,
            cmc.requires_date_interval? ? previous_reading.try(:taken_at) : nil
        ).try(:to_s)
      end
    end
    val
  end

  def as_json(options={})
    super(options.merge(:include => [:asset])).merge({
                                                         :data => JSON.parse(self.data),
                                                         :field_log => self.field_log.as_json
                                                     })
  end
end
