ActiveAdmin.register Asset do
  menu :parent => 'Site Management'

  index do
    column :unique_identifier
    column :location
    column :section
    column :monitor_class
    column 'Monitor Points' do |asset|
      asset.monitor_points.map {|mp| "#{mp.name}"}
    end
    default_actions
  end

  show do
    panel 'Details' do
      h6 "ID: #{asset.unique_identifier}"
      h6 asset.name
      h6 asset.location.site_name
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
      f.input :unique_identifier
      f.input :name
      f.input :location, :as => :select, :collection => Location.all
      f.input :section, :as => :select, :collection => asset.available_sections
      f.input :monitor_class, :as => :select, :collection => MonitorClass.all
      f.input :monitor_points, :as => :select, :collection => MonitorPoint.all, :input_html => {:style => 'height: 400px; width: 300px;'}
    end
    f.actions
  end
end
