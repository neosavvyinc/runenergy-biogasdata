class ChangeFlareIdToFlareUid < ActiveRecord::Migration
  def up
    rename_column :flare_specifications, :flare_id, :flare_unique_identifier
  end

  def down
    rename_column :flare_specifications, :flare_unique_identifier, :flare_id
  end
end
