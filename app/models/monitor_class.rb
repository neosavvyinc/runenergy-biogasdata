class MonitorClass < ActiveRecord::Base
  attr_accessible :name, :monitor_point_ids, :field_log_point_ids, :asset_ids, :location_ids
  has_many :readings
  has_many :monitor_classes_monitor_points
  has_many :monitor_points, through: :monitor_classes_monitor_points
  has_many :locations_monitor_classes
  has_many :locations, through: :locations_monitor_classes
  has_many :monitor_classes_field_log_points
  has_many :field_log_points, through: :monitor_classes_field_log_points

  def monitor_points_for_all_locations
    LocationsMonitorClass.where(:monitor_class_id => self.id).
        collect { |lmc| lmc.monitor_points }.
        flatten
  end
end
