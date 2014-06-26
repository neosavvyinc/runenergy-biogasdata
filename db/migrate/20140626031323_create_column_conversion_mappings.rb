class CreateColumnConversionMappings < ActiveRecord::Migration
  def change
    create_table :column_conversion_mappings do |t|
      t.string :from
      t.string :to
      t.integer :ignored_column_or_conversion_id

      t.timestamps
    end
  end
end
