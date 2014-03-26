class AddFolderToFtpDetail < ActiveRecord::Migration
  def change
    add_column :ftp_details, :folder_path, :string
  end
end
