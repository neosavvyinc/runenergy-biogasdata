class ChangeFlareDeploymentStatusToUseStatusCode < ActiveRecord::Migration
  def up
    remove_column :flare_deployment_statuses, :status
    add_column :flare_deployment_statuses, :flare_deployment_status_code_id, :integer
  end

  def down
    remove_column :flare_deployment_statuses, :flare_deployment_status_code_id
    add_column :flare_deployment_statuses, :status, :string
  end
end
