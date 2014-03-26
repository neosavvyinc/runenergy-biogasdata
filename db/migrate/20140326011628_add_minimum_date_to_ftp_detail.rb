class AddMinimumDateToFtpDetail < ActiveRecord::Migration
  def change
    add_column :ftp_details, :minimum_date, :date
  end
end
