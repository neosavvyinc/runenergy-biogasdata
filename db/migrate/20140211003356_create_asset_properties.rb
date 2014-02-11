class CreateAssetProperties < ActiveRecord::Migration
  def change
    create_table :asset_properties do |t|
      t.integer :monitor_class_id
      t.string :name

      t.timestamps
    end
  end
end
