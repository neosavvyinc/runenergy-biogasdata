class CreateFtpColumnMonitorPoints < ActiveRecord::Migration
  def change
    create_table :ftp_column_monitor_points do |t|
      t.integer :ftp_detail_id
      t.integer :monitor_point_id
      t.string :format

      t.timestamps
    end
  end
end
