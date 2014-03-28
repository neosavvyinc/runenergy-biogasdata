ActiveAdmin.register Section do
  menu :parent => 'Site Management'

  index do
    column :display_name
    column 'Assets' do |section|
      section.assets.map {|asset| asset.unique_identifier || asset.display_name}
    end
    default_actions
  end

  form do |f|
    f.inputs 'Section' do
      f.input :name
      f.input :location, :as => :select, :collection => Location.all
      f.input :assets, :as => :select, :collection => Asset.all, :input_html => {:style => 'height: 200px; width: 300px;'}
    end
    f.actions
  end

end
