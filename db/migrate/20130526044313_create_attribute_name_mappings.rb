class CreateAttributeNameMappings < ActiveRecord::Migration
  def change
    create_table :attribute_name_mappings do |t|
      t.string :attribute_name
      t.string :display_name
      t.string :applies_to_class

      t.timestamps
    end
  end
end
