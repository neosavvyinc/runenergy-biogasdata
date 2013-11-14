class CreateReadings < ActiveRecord::Migration
  def change
    create_table :readings do |t|
      t.datetime :taken_at
      t.string :data

      t.timestamps
    end
  end
end
