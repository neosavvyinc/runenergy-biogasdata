ActiveAdmin.register Asset do
  menu :parent => 'Site Management'

  index do
    column :name
    column :section
    column 'Monitor Points' do |asset|
      asset.monitor_points.map {|mp| "#{mp.name}"}
    end
    default_actions
  end

  show do
    panel 'Details' do
      h6 "ID: #{asset.id}"
      h6 asset.name
      h6 asset.section.display_name
      h6 "Created At: #{asset.created_at}"
      h6 "Updated At: #{asset.updated_at}"
    end
    panel 'Monitor Points' do
      table_for asset.monitor_points do
        column :name
        column :unit
      end
    end
  end

  form do |f|
    f.inputs 'Asset' do
      f.input :name
      f.input :section, :as => :select, :collection => asset.available_sections
      f.input :monitor_classes, :as => :select, :collection => MonitorClass.all
      f.input :monitor_points, :as => :select, :collection => MonitorPoint.all
    end
    f.actions
  end
end
