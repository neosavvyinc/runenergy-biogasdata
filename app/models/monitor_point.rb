class MonitorPoint < ActiveRecord::Base
  attr_accessible :name, :unit
  has_many :monitor_classes_monitor_points
  has_many :monitor_classes, through: :monitor_classes_monitor_points
  has_many :monitor_limits
  has_many :assets_monitor_points
  has_many :assets, :through => :assets_monitor_points

  def snake_name
    name.gsub(/\s{1,}/, '_').downcase
  end
end
