class MergeFlareDeploymentStatusWithFlareDeployment < ActiveRecord::Migration
  def change
    drop_table :flare_deployment_statuses
    add_column :flare_deployments, :first_reading, :date
    add_column :flare_deployments, :last_reading, :date
    add_column :flare_deployments, :flare_deployment_status_code_id, :integer
  end
end
