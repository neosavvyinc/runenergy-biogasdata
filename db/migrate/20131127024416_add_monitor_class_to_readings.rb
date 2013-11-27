class AddMonitorClassToReadings < ActiveRecord::Migration
  def change
    add_column :readings, :monitor_class_id, :integer
  end
end
