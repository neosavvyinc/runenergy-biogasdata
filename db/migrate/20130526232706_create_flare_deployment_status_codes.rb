class CreateFlareDeploymentStatusCodes < ActiveRecord::Migration
  def change
    create_table :flare_deployment_status_codes do |t|
      t.string :name

      t.timestamps
    end
  end
end
