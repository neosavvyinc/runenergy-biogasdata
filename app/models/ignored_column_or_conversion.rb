class IgnoredColumnOrConversion < ActiveRecord::Base
  attr_accessible :convert_to, :ignore, :column_conversion_mappings_monitor_class_id
  has_many :column_conversion_mappings_monitor_classes
  has_many :monitor_classes, :through => :column_conversion_mappings_monitor_classes
end
