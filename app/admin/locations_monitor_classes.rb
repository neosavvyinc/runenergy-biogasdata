ActiveAdmin.register LocationsMonitorClass, :as => 'Site Monitor Classes' do
  menu :parent => 'Site Management'

  index do
    column :display_name
    default_actions
  end

  form do |f|
    f.inputs 'Site Specific Assignments' do
      f.input :location, :as => :select, :collection => Location.all
      f.input :monitor_class, :as => :select, :collection => MonitorClass.all
      f.input :field_log_points, :as => :select, :collection => FieldLogPoint.all, :input_html => {:style => 'height: 300px; width: 300px;'}
      f.input :monitor_points, :as => :select, :collection => MonitorPoint.all, :input_html => {:style => 'height: 300px; width: 300px;'}
      f.has_many :custom_monitor_calculations, :allow_destroy => true do |cmc|
        cmc.input :value
      end
    end
    f.actions
  end
end
