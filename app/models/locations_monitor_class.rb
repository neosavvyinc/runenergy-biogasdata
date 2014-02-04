class LocationsMonitorClass < ActiveRecord::Base
  attr_accessible :location_id, :monitor_class_id, :monitor_point_ids, :column_cache, :deleted_column_cache, :asset_column_name
  belongs_to :location
  belongs_to :monitor_class
  has_many :exception_notifications
  has_many :field_log_points_locations_monitor_classes
  has_many :field_log_points, :through => :field_log_points_locations_monitor_classes
  has_many :monitor_points_locations_monitor_classes
  has_many :monitor_points, :through => :monitor_points_locations_monitor_classes

  validates_presence_of :location, :monitor_class

  def self.lazy_load(location_id, monitor_class_id)
    locations_monitor_class = LocationsMonitorClass.where(:location_id => location_id, :monitor_class_id => monitor_class_id).first
    if locations_monitor_class.nil?
      locations_monitor_class = LocationsMonitorClass.create(:location_id => location_id, :monitor_class_id => monitor_class_id)
    end
    locations_monitor_class
  end

  def self.create_caches(location_id, monitor_class_id, column_mapping, deleted_columns, asset_column_name)
    locations_monitor_class = self.lazy_load(location_id, monitor_class_id)
    locations_monitor_class.column_cache = column_mapping.to_json
    locations_monitor_class.deleted_column_cache = deleted_columns.to_json
    locations_monitor_class.asset_column_name = asset_column_name
    locations_monitor_class.save

    #Return value
    locations_monitor_class
  end

  def display_name
    "#{location.try(:site_name)} - #{monitor_class.try(:name).try(:pluralize)}"
  end

  def notifications_for(reading)
    unless reading.nil? or exception_notifications.empty?
      unless reading.location_id != location_id
        data = JSON.parse(reading.data)
        data.each do |k, v|
          mp = MonitorPoint.find_by_name(k)
          unless mp.nil?
            ml = mp.monitor_limit_for_location(location_id)
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

  def as_json(options={})
    super(options).merge({
                             'column_cache' => (self.column_cache ? JSON.parse(self.column_cache) : nil),
                             'deleted_column_cache' => (self.deleted_column_cache ? JSON.parse(self.deleted_column_cache) : nil)
                         })
  end
end