class CreateFlareCollectionStatistics < ActiveRecord::Migration
  def change
    create_table :flare_collection_statistics do |t|
      t.date :last_reading_collected

      t.timestamps
    end
  end
end
