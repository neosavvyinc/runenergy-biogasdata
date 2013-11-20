class CreateMonitorClassMonitorPointJoinTable < ActiveRecord::Migration
  def change
    create_table :monitor_classes_monitor_points, :id => false do |t|
      t.integer :monitor_class_id
      t.integer :monitor_point_id
    end
  end
end
