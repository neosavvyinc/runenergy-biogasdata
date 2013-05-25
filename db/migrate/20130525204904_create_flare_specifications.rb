class CreateFlareSpecifications < ActiveRecord::Migration
  def change
    create_table :flare_specifications do |t|
      t.string :flare_id
      t.integer :capacity_scmh
      t.integer :manufacturer_id
      t.date :purchase_date
      t.string :manufacturer_product_id
      t.integer :owner_id
      t.string :web_address
      t.string :ftp_address
      t.string :username
      t.string :password
      t.string :data_location

      t.timestamps
    end
  end
end
