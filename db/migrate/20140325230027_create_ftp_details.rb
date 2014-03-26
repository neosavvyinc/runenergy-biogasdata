class CreateFtpDetails < ActiveRecord::Migration
  def change
    create_table :ftp_details do |t|
      t.integer :asset_id
      t.string :username
      t.string :password
      t.text :url

      t.timestamps
    end
  end
end
