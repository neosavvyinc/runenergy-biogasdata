class CreateExceptionNotifications < ActiveRecord::Migration
  def change
    create_table :exception_notifications do |t|
      t.integer :locations_monitor_class_id
      t.integer :user_id
      t.string :other_email

      t.timestamps
    end
  end
end
