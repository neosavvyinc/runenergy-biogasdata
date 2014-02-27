class AssetProperty < ActiveRecord::Base
  attr_accessible :monitor_class_id, :name
  belongs_to :monitor_class
  has_many :asset_property_values

  validates_presence_of :name
end
