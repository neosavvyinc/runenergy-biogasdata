class IgnoredColumnOrConversion < ActiveRecord::Base
  attr_accessible :convert_to, :ignore
  has_many :ignored_columns_or_conversions_monitor_classes
  has_many :monitor_classes, :through => :ignored_columns_or_conversions_monitor_classes
  has_many :column_conversion_mappings
end
