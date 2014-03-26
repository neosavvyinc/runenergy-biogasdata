class AddLastDateCollectedToFtpDetail < ActiveRecord::Migration
  def change
    add_column :ftp_details, :last_date_collected, :date
  end
end
