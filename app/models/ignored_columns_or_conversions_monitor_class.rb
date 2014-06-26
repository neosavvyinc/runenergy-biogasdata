class IgnoredColumnsOrConversionsMonitorClass < ActiveRecord::Base
  attr_accessible :ignored_column_or_conversion_id, :monitor_class_id
  belongs_to :ignored_column_or_conversion
  belongs_to :monitor_class
end
