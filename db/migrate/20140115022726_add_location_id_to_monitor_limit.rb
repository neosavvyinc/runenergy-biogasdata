class AddLocationIdToMonitorLimit < ActiveRecord::Migration
  def change
    add_column :monitor_limits, :location_id, :integer
  end
end
