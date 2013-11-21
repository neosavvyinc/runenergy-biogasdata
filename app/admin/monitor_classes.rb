ActiveAdmin.register MonitorClass do

  menu :parent => 'Monitored Settings'

  show do
    panel "Monitor Points" do
      table_for monitor_class.monitor_points do
        column :name
        column :unit
      end
    end
    panel "Details" do
      h6 "Created At: #{monitor_class.created_at}"
      h6 "Updated At: #{monitor_class.updated_at}"
    end
  end

  form do |f|
    f.inputs 'Monitor Class' do
      f.input :name
      f.input :monitor_points, :as => :select, :collection => MonitorPoint.all
      #f.has_many :monitor_points do |mp|
      #  mp.inputs "Monitor Points" do
      #    mp.input :name
      #    mp.input :unit
      #    #repeat as necessary for all fields
      #  end
      #end
    end
    f.actions
  end

end