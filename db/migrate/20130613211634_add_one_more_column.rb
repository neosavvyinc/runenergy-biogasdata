class AddOneMoreColumn < ActiveRecord::Migration
  def change
    change_column :flare_data_mappings, :standard_lfg_volume_column, :string
  end
end
