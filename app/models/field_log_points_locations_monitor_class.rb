class FieldLogPointsLocationsMonitorClass < ActiveRecord::Base
  attr_accessible :field_log_point_id
  attr_accessible :locations_monitor_class_id
  belongs_to :field_log_point
  belongs_to :locations_monitor_class
end
