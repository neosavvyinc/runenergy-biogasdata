class AddColumnNameToIgnoredColumnOrConversion < ActiveRecord::Migration
  def change
    add_column :ignored_column_or_conversions, :column_name, :string
  end
end
