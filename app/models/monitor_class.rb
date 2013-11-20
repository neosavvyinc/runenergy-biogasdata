class MonitorClass < ActiveRecord::Base
  attr_accessible :name
  has_many :readings
  has_many :monitor_classes_monitor_points
  has_many :monitor_points, through: :monitor_classes_monitor_points
end
