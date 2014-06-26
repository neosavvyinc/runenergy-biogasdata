ActiveAdmin.register IgnoredColumnOrConversion do

  form do |f|
    f.inputs 'Column Conversion Mappings' do
      f.input :ignore
      f.input :convert_to
      f.has_many :column_conversion_mappings, :allow_destroy => true do |cmc|
        cmc.input :from
        cmc.input :to
        cmc.input :_destroy, :as => :boolean, :label => 'Remove from column conversion'
      end
    end
    f.actions
  end

end
