class AddNameToDataMappings < ActiveRecord::Migration
  def change
    add_column :flare_data_mappings, :name, :string
  end
end
