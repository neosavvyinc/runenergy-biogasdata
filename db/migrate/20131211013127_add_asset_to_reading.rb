class AddAssetToReading < ActiveRecord::Migration
  def change
    add_column :readings, :asset_id, :integer
  end
end
