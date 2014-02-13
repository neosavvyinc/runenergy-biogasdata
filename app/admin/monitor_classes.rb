ActiveAdmin.register MonitorClass do

  menu :parent => 'Site Management'

  index do
    column :name
    column 'Field Log Points' do |mc|
      mc.field_log_points.map {|flp| flp.name}
    end
    column 'Sites' do |mc|
      mc.locations.map {|l| l.site_name}
    end
    default_actions
  end

  show do
    panel 'Details' do
      h6 monitor_class.name
      h6 "Created At: #{monitor_class.created_at}"
      h6 "Updated At: #{monitor_class.updated_at}"
    end
    panel 'Field Log Points' do
      table_for monitor_class.field_log_points do
        column :name
      end
    end
  end

  form do |f|
    f.inputs 'Monitor Class' do
      f.input :name
      f.input :field_log_points, :as => :select, :collection => FieldLogPoint.all, :input_html => {:style => 'height: 100px; width: 300px;'}
      f.input :locations, :as => :select, :collection => Location.all, :input_html => {:style => 'height: 300px; width: 300px;'}
      f.input :monitor_point_ordering
      f.input :asset_properties, :as => :select, :collection => AssetProperty.all, :input_html => {:style => 'height: 300px; width: 300px;'}
      f.has_many :asset_properties, :allow_destroy => true, :heading => 'Asset Properties', :new_record => false do |ap|
        ap.input :name
      end
    end
    f.actions
  end

  before_save :check_monitor_point_ordering

  controller do
    def check_monitor_point_ordering(obj)
      flash[:error] ||= []
      flash[:error] << 'Some error here!'
    end
  end

end
