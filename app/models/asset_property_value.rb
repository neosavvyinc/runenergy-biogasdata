class AssetPropertyValue < ActiveRecord::Base
  attr_accessible :asset_id, :asset_property_id, :value
  belongs_to :asset
  belongs_to :asset_property
end
