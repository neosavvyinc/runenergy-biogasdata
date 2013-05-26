class CreateFlareDeploymentStatuses < ActiveRecord::Migration
  def change
    create_table :flare_deployment_statuses do |t|
      t.string :status
      t.date :first_reading
      t.date :last_reading
      t.integer :flare_deployment_id

      t.timestamps
    end
  end
end
