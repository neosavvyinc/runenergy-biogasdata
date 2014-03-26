class AddPauseToFtpDetail < ActiveRecord::Migration
  def change
    add_column :ftp_details, :pause, :boolean
  end
end
