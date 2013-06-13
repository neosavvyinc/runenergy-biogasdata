class CreateCsvMappingPairs < ActiveRecord::Migration
  def change
    create_table :csv_mapping_pairs do |t|

      t.timestamps
    end
  end
end
