class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :site_name
      t.text :address
      t.integer :state_id
      t.integer :country_id
      t.string :lattitude
      t.string :longitude

      t.timestamps
    end
  end
end
