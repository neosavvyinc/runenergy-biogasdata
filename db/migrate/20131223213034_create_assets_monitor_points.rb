class CreateAssetsMonitorPoints < ActiveRecord::Migration
  def change
    create_table :assets_monitor_points, :id => false do |t|
      t.integer :asset_id
      t.integer :monitor_point_id

      t.timestamps
    end
  end
end
