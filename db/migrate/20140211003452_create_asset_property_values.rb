class CreateAssetPropertyValues < ActiveRecord::Migration
  def change
    create_table :asset_property_values do |t|
      t.string :value
      t.integer :asset_property_id
      t.integer :asset_id

      t.timestamps
    end
  end
end
