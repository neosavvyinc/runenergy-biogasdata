class AddUniqueIdentifierToAsset < ActiveRecord::Migration
  def change
    add_column :assets, :unique_identifier, :string
  end
end
