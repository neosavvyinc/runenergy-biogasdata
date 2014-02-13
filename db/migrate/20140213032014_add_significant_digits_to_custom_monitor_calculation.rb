class AddSignificantDigitsToCustomMonitorCalculation < ActiveRecord::Migration
  def change
    add_column :custom_monitor_calculations, :significant_digits, :integer
  end
end
