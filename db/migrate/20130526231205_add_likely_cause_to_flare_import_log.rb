class AddLikelyCauseToFlareImportLog < ActiveRecord::Migration
  def change
    add_column :flare_import_logs, :likely_cause, :string
  end
end
