class AddDataCollisionToReading < ActiveRecord::Migration
  def change
    add_column :readings, :data_collision_id, :integer
  end
end
