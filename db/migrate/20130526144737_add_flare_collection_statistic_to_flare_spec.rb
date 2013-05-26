class AddFlareCollectionStatisticToFlareSpec < ActiveRecord::Migration
  def change
    add_column :flare_specifications, :flare_collection_statistic_id, :integer
  end
end
