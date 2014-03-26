class AddDateColumnNameToFtpDetail < ActiveRecord::Migration
  def change
    add_column :ftp_details, :date_column_name, :string
  end
end
