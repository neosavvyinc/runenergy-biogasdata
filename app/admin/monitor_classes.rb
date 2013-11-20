ActiveAdmin.register MonitorClass do

  menu :parent => 'Monitored Settings'

  form do |f|
    f.inputs 'Monitor Class' do
      f.input :name
      f.has_many :monitor_classes_monitor_points do |app_f|
        app_f.inputs "Monitor Points" do
          if !app_f.object.nil?
            # show the destroy checkbox only if it is an existing appointment
            # else, there's already dynamic JS to add / remove new appointments
            app_f.input :_destroy, :as => :boolean, :label => "Destroy?"
          end

          app_f.input :monitor_point # it should automatically generate a drop-down select to choose from your existing patients
        end
      end
    end
    f.actions
  end

end
