class CreateFieldLogs < ActiveRecord::Migration
  def change
    create_table :field_logs do |t|
      t.timestamp :taken_at
      t.string :data

      t.timestamps
    end
  end
end
