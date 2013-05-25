class CreateFlareDeployments < ActiveRecord::Migration
  def change
    create_table :flare_deployments do |t|
      t.string :flare_id
      t.integer :location_id
      t.integer :customer_id
      t.string :client_flare_id
      t.integer :flare_data_mapping_id

      t.timestamps
    end
  end
end
