class AddNameToCustomMonitorCalculation < ActiveRecord::Migration
  def change
    add_column :custom_monitor_calculations, :name, :string
  end
end
