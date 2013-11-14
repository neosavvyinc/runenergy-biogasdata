class MonitorLimit < ActiveRecord::Base
  attr_accessible :upper_limit, :lower_limit
  belongs_to :monitor_point
end
