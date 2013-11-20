class MonitorClassesMonitorPoint < ActiveRecord::Base
  attr_accessible :monitor_class_id, :monitor_point_id
  belongs_to :monitor_class
  belongs_to :monitor_point

end