class MonitorLimit < ActiveRecord::Base
  attr_accessible :upper_limit, :lower_limit, :locations_monitor_class_id, :monitor_point_id
  belongs_to :monitor_point
  belongs_to :locations_monitor_class

  validates_presence_of :lower_limit, :upper_limit

end
