ActiveAdmin.register MonitorLimit do

  menu :parent => 'Site Management'

  index do
    column :monitor_point
    column :lower_limit
    column :upper_limit
    default_actions
  end

end
