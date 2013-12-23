class AssetsMonitorPoint < ActiveRecord::Base
  attr_accessible :asset_id, :monitor_point_id
  belongs_to :asset
  belongs_to :monitor_point
end
