class LocationsMonitorClass < ActiveRecord::Base
  attr_accessible :location_id, :monitor_class_id
  belongs_to :location
  belongs_to :monitor_class
end