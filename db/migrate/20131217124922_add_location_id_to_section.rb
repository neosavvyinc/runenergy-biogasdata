class AddLocationIdToSection < ActiveRecord::Migration
  def change
    add_column :sections, :location_id, :integer
  end
end
