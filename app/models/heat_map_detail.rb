class HeatMapDetail < ActiveRecord::Base
  attr_accessible :asset_id, :symbol_id, :x, :y
  belongs_to :asset
end
