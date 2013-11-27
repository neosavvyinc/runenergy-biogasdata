class AddLocationToReading < ActiveRecord::Migration
  def change
    add_column :readings, :location_id, :integer
  end
end
