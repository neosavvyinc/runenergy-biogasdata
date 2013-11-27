class Reading < ActiveRecord::Base
  attr_accessible :taken_at, :data, :monitor_class_id, :field_log_id
  belongs_to :monitor_class
  belongs_to :field_log
end
