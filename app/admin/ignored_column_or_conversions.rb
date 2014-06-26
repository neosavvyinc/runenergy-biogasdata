ActiveAdmin.register IgnoredColumnOrConversion do

  menu :parent => 'API Management'

  form do |f|
    f.inputs 'Column Conversion Mappings' do
      f.input :ignore, :label => 'Remove Column From Data Without Converting'
      f.input :column_name
      f.input :convert_to
      f.input :monitor_classes, :as => :select, :collection => MonitorClass.all, :input_html => {:style => 'height: 300px; width: 300px;'}
      f.has_many :column_conversion_mappings, :allow_destroy => true do |cmc|
        cmc.input :from
        cmc.input :to
        cmc.input :comment_entry, :label => 'Add as comment instead'
        cmc.input :_destroy, :as => :boolean, :label => 'Remove from column conversion'
      end
    end
    f.actions
  end

end
