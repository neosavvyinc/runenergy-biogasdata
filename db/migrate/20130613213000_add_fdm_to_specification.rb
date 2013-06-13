class AddFdmToSpecification < ActiveRecord::Migration
  def change
    add_column :flare_specifications, :flare_data_mapping_id, :integer
  end
end
