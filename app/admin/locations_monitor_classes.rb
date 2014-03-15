ActiveAdmin.register LocationsMonitorClass, :as => 'Site Monitor Classes' do
  menu :parent => 'Site Management'

  index do
    column :display_name
    default_actions
  end

  show do
    panel 'Details' do
      h6 site_monitor_classes.location.site_name
      h6 site_monitor_classes.monitor_class.name
    end
    panel 'Field Log Points' do
      site_monitor_classes.field_log_points.each do |flp|
        h6 flp.name
      end
    end
    panel 'Monitor Points' do
      site_monitor_classes.monitor_points.each do |mp|
        h6 "#{mp.name} (#{mp.unit})"
      end
    end
    panel 'Custom Monitor Calculations' do
      site_monitor_classes.custom_monitor_calculations.each do |cmc|
        h6 "#{cmc.name}: #{cmc.value}"
      end
    end
  end

  form do |f|
    f.inputs 'Site Specific Assignments' do
      f.input :location, :as => :select, :collection => Location.all
      f.input :monitor_class, :as => :select, :collection => MonitorClass.all
      f.input :field_log_points, :as => :select, :collection => FieldLogPoint.all, :input_html => {:style => 'height: 300px; width: 300px;'}
      f.input :monitor_points, :as => :select, :collection => MonitorPoint.all, :input_html => {:style => 'height: 300px; width: 300px;'}
      f.has_many :custom_monitor_calculations, :allow_destroy => true do |cmc|
        cmc.input :name
        cmc.input :value
        cmc.input :significant_digits
        cmc.input :_destroy, :as => :boolean, :label => 'Remove From Sites Monitor Class'
      end
    end
    f.actions
  end
end
