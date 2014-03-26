class AddColumnNameToFtpColumnMonitorPoint < ActiveRecord::Migration
  def change
    add_column :ftp_column_monitor_points, :column_name, :string
  end
end
