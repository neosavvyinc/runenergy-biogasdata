class RenameFlareIdInFlareDeployment < ActiveRecord::Migration
  def up
    rename_column :flare_deployments, :flare_id, :flare_specification_id
  end

  def down
    rename_column :flare_deployments, :flare_specification_id, :flare_id
  end
end
