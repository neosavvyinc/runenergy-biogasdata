class CreateDataCollisions < ActiveRecord::Migration
  def change
    create_table :data_collisions do |t|

      t.timestamps
    end
  end
end
