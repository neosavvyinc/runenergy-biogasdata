class CreateFieldLogPoints < ActiveRecord::Migration
  def change
    create_table :field_log_points do |t|
      t.string :name

      t.timestamps
    end
  end
end
