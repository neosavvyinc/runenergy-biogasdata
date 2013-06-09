class AddColumnWeightToAttributes < ActiveRecord::Migration
  def change
    add_column :attribute_name_mappings, :column_weight, :integer
  end
end
