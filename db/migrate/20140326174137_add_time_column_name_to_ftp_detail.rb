class AddTimeColumnNameToFtpDetail < ActiveRecord::Migration
  def change
    add_column :ftp_details, :time_column_name, :string
  end
end
