ActiveAdmin.register Section do
  menu :parent => 'Site Management'

  form do |f|
    f.inputs 'Section' do
      f.input :name
      f.input :location, :as => :select, :collection => Location.all
      f.input :assets, :as => :select, :collection => Asset.all
    end
    f.actions
  end

end
