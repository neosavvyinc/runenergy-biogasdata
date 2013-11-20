class MonitorPoint < ActiveRecord::Base
  attr_accessible :name, :unit
  has_many :monitor_classes_monitor_points
  has_many :monitor_classes, through: :monitor_classes_monitor_points
  has_many :monitor_limits
end
