class CreateMonitorPoints < ActiveRecord::Migration
  def change
    create_table :monitor_points do |t|
      t.string :name
      t.string :unit

      t.timestamps
    end
  end
end
