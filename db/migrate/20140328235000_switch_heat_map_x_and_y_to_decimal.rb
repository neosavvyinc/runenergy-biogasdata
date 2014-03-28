class SwitchHeatMapXAndYToDecimal < ActiveRecord::Migration
  def change
    change_column :heat_map_details, :x, :string
    change_column :heat_map_details, :y, :string
  end
end
