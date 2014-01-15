class LocationsMonitorClass < ActiveRecord::Base
  attr_accessible :location_id, :monitor_class_id, :monitor_point_ids
  belongs_to :location
  belongs_to :monitor_class
  has_many :monitor_points_locations_monitor_classes
  has_many :monitor_points, :through => :monitor_points_locations_monitor_classes

  validates_presence_of :location, :monitor_class

  def display_name
    "#{location.site_name} - #{monitor_class.name.pluralize}"
  end
end