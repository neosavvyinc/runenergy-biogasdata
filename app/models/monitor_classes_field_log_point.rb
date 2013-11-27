class MonitorClassesFieldLogPoint < ActiveRecord::Base
  attr_accessible :field_log_point_id, :monitor_class_id
  belongs_to :field_log_point
  belongs_to :monitor_class
end
