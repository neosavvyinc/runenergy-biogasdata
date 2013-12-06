class MonitorPoint < ActiveRecord::Base
  attr_accessible :name, :unit
  has_many :monitor_classes_monitor_points
  has_many :monitor_classes, through: :monitor_classes_monitor_points
  has_many :monitor_limits

  def snake_name
    name.gsub(/\s{1,}/, '_').lower
  end

  def as_json(options={})
    super(options).merge(:snake_name => snake_name)
  end
end
