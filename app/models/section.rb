class Section < ActiveRecord::Base
  attr_accessible :monitor_class_id, :name
  belongs_to :monitor_class
end
