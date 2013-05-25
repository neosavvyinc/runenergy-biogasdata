class CreateStates < ActiveRecord::Migration
  def change
    create_table :states do |t|
      t.string :name
      t.string :postal_code

      t.timestamps
    end
  end
end
