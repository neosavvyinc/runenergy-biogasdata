class RemoveDateAndTimeFromFlareDataMapping < ActiveRecord::Migration
  def change
    remove_column :flare_data_mappings, :date_reading_column
    remove_column :flare_data_mappings, :time_reading_column
  end
end
