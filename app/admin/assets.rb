ActiveAdmin.register Asset do
  menu :parent => 'Site Management'

  form do |f|
    f.inputs 'Asset' do
      f.input :name
      f.input :section, :as => :select, :collection => Section.all
      f.input :monitor_classes, :as => :select, :collection => MonitorClass.all
    end
    f.actions
  end
end
