class RenameClientFlareIdColumn < ActiveRecord::Migration
  def up
    rename_column :flare_deployments, :client_flare_id, :client_flare_unique_identifier
  end

  def down
    rename_column :flare_deployments, :client_flare_unique_identifier, :client_flare_id
  end
end
