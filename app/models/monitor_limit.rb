class MonitorLimit < ActiveRecord::Base
  attr_accessible :upper_limit, :lower_limit, :location_id, :monitor_point_id
  belongs_to :monitor_point
  belongs_to :location
end
