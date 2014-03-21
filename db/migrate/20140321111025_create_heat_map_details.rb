class CreateHeatMapDetails < ActiveRecord::Migration
  def change
    create_table :heat_map_details do |t|
      t.integer :x
      t.integer :y
      t.integer :symbol_id
      t.integer :asset_id

      t.timestamps
    end
  end
end
