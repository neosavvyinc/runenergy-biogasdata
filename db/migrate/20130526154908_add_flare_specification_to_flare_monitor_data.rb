class AddFlareSpecificationToFlareMonitorData < ActiveRecord::Migration
  def change
    add_column :flare_monitor_data, :flare_specification_id, :integer
  end
end
