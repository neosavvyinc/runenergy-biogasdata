class CreateAssetsMonitorClasses < ActiveRecord::Migration
  def change
    create_table :assets_monitor_classes, :id => false do |t|
      t.integer :asset_id
      t.integer :monitor_class_id

      t.timestamps
    end
  end
end
