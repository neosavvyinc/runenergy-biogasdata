class FieldLogPoint < ActiveRecord::Base
  attr_accessible :name
  has_many :monitor_classes_field_log_points
  has_many :monitor_classes, through: :monitor_classes_field_log_points
end
