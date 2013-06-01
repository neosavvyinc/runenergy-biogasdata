class AddUnitsAndSignificantDigitsToAttributeNameMappings < ActiveRecord::Migration
  def change
    add_column :attribute_name_mappings, :units, :string
    add_column :attribute_name_mappings, :significant_digits, :integer
  end
end
