class CreateFtpImportLogs < ActiveRecord::Migration
  def change
    create_table :ftp_import_logs do |t|
      t.integer :ftp_detail_id
      t.text :error

      t.timestamps
    end
  end
end
