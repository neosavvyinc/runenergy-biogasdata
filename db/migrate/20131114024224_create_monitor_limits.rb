class CreateMonitorLimits < ActiveRecord::Migration
  def change
    create_table :monitor_limits do |t|
      t.decimal :limit, :precision => 10, :scale => 10

      t.timestamps
    end
  end
end
