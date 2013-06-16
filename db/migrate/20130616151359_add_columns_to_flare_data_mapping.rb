class AddColumnsToFlareDataMapping < ActiveRecord::Migration
  def change
    add_column :flare_data_mappings, :flame_trap_temperature_column, :string
    add_column :flare_data_mappings, :flare_run_hours_column, :string
  end
end
