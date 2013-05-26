class CreateFlareImportLogs < ActiveRecord::Migration
  def change
    create_table :flare_import_logs do |t|
      t.string :message
      t.integer :flare_specification_id

      t.timestamps
    end
  end
end
