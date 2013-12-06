class Asset < ActiveRecord::Base
  attr_accessible :name, :section_id, :monitor_class_ids
  belongs_to :section
  has_many :assets_monitor_classes
  has_many :monitor_classes, through: :assets_monitor_classes
end
