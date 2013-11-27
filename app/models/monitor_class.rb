class MonitorClass < ActiveRecord::Base
  attr_accessible :name, :monitor_point_ids
  has_many :readings
  has_many :monitor_classes_monitor_points
  has_many :monitor_points, through: :monitor_classes_monitor_points
  has_many :locations_monitor_classes
  has_many :locations, through: :locations_monitor_classes

  #Not sure if this is needed
  accepts_nested_attributes_for :monitor_classes_monitor_points
  accepts_nested_attributes_for :monitor_points, :allow_destroy => true
end
