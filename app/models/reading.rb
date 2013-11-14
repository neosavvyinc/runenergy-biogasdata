class Reading < ActiveRecord::Base
  attr_accessible :taken_at, :data
  belongs_to :monitor_class
end
