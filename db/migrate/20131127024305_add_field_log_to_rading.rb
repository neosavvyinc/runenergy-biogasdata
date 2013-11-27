class AddFieldLogToRading < ActiveRecord::Migration
  def change
    add_column :readings, :field_log_id, :integer
  end
end
