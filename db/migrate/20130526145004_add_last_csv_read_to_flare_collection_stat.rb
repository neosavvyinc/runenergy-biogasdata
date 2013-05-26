class AddLastCsvReadToFlareCollectionStat < ActiveRecord::Migration
  def change
    add_column :flare_collection_statistics, :last_csv_read, :string
  end
end
