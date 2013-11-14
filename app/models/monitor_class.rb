class MonitorClass < ActiveRecord::Base
  attr_accessible :name
  has_many :readings
  has_and_belongs_to_many :monitor_points
end
