class CreateMonitorClasses < ActiveRecord::Migration
  def change
    create_table :monitor_classes do |t|
      t.string :name

      t.timestamps
    end
  end
end
