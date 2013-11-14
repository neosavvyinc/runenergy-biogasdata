class MonitorPoint < ActiveRecord::Base
  attr_accessible :name, :unit
  has_and_belongs_to_many :monitor_classes
  has_many :monitor_limits
end
