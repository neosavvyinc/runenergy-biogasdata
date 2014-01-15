class CreateCustomMonitorCalculations < ActiveRecord::Migration
  def change
    create_table :custom_monitor_calculations do |t|
      t.string :value
      t.integer :monitor_point_id
      t.integer :asset_id

      t.timestamps
    end
  end
end
