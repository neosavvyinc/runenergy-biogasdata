class MonitorClass < ActiveRecord::Base
  attr_accessible :name, :monitor_point_ids, :field_log_point_ids, :asset_ids
  has_many :readings
  has_many :monitor_classes_monitor_points
  has_many :monitor_points, through: :monitor_classes_monitor_points
  has_many :locations_monitor_classes
  has_many :locations, through: :locations_monitor_classes
  has_many :monitor_classes_field_log_points
  has_many :field_log_points, through: :monitor_classes_field_log_points
  has_many :assets_monitor_classes
  has_many :assets, through: :assets_monitor_classes
end
