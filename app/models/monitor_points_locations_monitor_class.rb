class MonitorPointsLocationsMonitorClass < ActiveRecord::Base
  attr_accessible :locations_monitor_class_id, :monitor_point_id
  belongs_to :locations_monitor_class
  belongs_to :monitor_point
end
