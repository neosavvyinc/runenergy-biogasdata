class MonitorLimit < ActiveRecord::Base
  attr_accessible :limit
  belongs_to :monitor_point
end
