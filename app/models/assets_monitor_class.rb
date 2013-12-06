class AssetsMonitorClass < ActiveRecord::Base
  attr_accessible :asset_id, :monitor_class_id
  belongs_to :asset
  belongs_to :monitor_class
end
