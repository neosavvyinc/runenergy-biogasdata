class LocationsMonitorClass < ActiveRecord::Base
  attr_accessible :location_id, :monitor_class_id, :field_log_point_ids, :monitor_point_ids, :column_cache, :deleted_column_cache, :asset_column_name, :date_column_name, :date_format, :custom_monitor_calculations_attributes, :monitor_limit_ids
  belongs_to :location
  belongs_to :monitor_class
  has_many :exception_notifications
  has_many :field_log_points_locations_monitor_classes, :uniq => true
  has_many :field_log_points, :through => :field_log_points_locations_monitor_classes
  has_many :monitor_points_locations_monitor_classes, :uniq => true
  has_many :monitor_points, :through => :monitor_points_locations_monitor_classes
  has_many :custom_monitor_calculations
  has_many :monitor_limits

  accepts_nested_attributes_for :custom_monitor_calculations, :allow_destroy => true

  UPPER_LIMIT_WARNING = 'upper_limit'
  LOWER_LIMIT_WARNING = 'lower_limit'

  def self.lazy_load(location_id, monitor_class_id)
    locations_monitor_class = LocationsMonitorClass.where(:location_id => location_id, :monitor_class_id => monitor_class_id).first
    if locations_monitor_class.nil?
      locations_monitor_class = LocationsMonitorClass.create(:location_id => location_id, :monitor_class_id => monitor_class_id)
    end
    locations_monitor_class
  end

  def self.create_caches(location_id, monitor_class_id, column_mapping, deleted_columns, asset_column_name = nil, date_column_name = nil, date_format = nil)
    locations_monitor_class = self.lazy_load(location_id, monitor_class_id)
    locations_monitor_class.column_cache = column_mapping.to_json
    locations_monitor_class.deleted_column_cache = deleted_columns.to_json
    locations_monitor_class.asset_column_name = asset_column_name
    locations_monitor_class.date_column_name = date_column_name
    locations_monitor_class.date_format = date_format
    locations_monitor_class.save

    #Return value
    locations_monitor_class
  end

  def display_name
    "#{location.try(:site_name)} - #{monitor_class.try(:name).try(:pluralize)}"
  end

  def calculation_names
    if custom_monitor_calculations and custom_monitor_calculations.size
      custom_monitor_calculations.map {|cmc| cmc.name}
    else
      []
    end
  end

  def notifications_for(reading)
    unless reading.nil? or exception_notifications.empty?
      unless reading.location_id != location_id
        data = JSON.parse(reading.data)
        data.each do |k, v|
          mp = MonitorPoint.find_by_name(k)
          unless mp.nil?
            ml = mp.monitor_limit_for_locations_monitor_class(self.id)
            unless ml.nil?
              if ml.try(:lower_limit) and v.to_f < ml.try(:lower_limit).to_f
                exception_notifications.each do |en|
                  en.lower_limit_warning(self, mp, ml, reading)
                end
              elsif ml.try(:lower_limit) and v.to_f > ml.try(:upper_limit).to_f
                exception_notifications.each do |en|
                  en.upper_limit_warning(self, mp, ml, reading)
                end
              end
            end
          end
        end
      else
        raise 'You have passed a reading into a locations monitor class to which it does not belong'
      end
    end
  end

  def notifications_for_batch(readings, deleted, type)
    if exception_notifications and (type == UPPER_LIMIT_WARNING or type == LOWER_LIMIT_WARNING)
      unless readings.size == 1 and (deleted.nil? or deleted.empty?)
        exception_notifications.each do |en|
          if type == UPPER_LIMIT_WARNING
            en.batch_upper_limit_warning(self, readings, deleted)
          else
            en.batch_lower_limit_warning(self, readings, deleted)
          end
        end
      else
        notifications_for(readings.first)
      end
    else
      raise 'You have passed in invalid warning type for a batch notification'
    end
  end

  def as_json(options={})
    super(options).merge({
                             'column_cache' => (self.column_cache ? JSON.parse(self.column_cache) : nil),
                             'deleted_column_cache' => (self.deleted_column_cache ? JSON.parse(self.deleted_column_cache) : nil)
                         })
  end
end