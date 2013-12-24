ActiveAdmin.register MonitorPoint do

  menu :parent => 'Site Management'

  index do
    column :name
    column :unit
    default_actions
  end

  show do
    panel 'Details' do
      h6 "Name: #{monitor_point.name}"
      h6 "Unit: #{monitor_point.unit}"
    end
  end

end
