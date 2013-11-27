class CreateMonitorClassesFieldLogPoints < ActiveRecord::Migration
  def change
    create_table :monitor_classes_field_log_points, :id => false do |t|
      t.integer :monitor_class_id
      t.integer :field_log_point_id
    end
  end
end
