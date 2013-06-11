ActiveAdmin.register Location, :as => "Site" do
  menu :parent => "Locations"

  index do
    column :site_name
    column :address
    column :lattitu
    column :longitude
    default_actions
  end

  form do |f|
    f.inputs "Site" do
      f.input :site_name
      f.input :address, :as => :text
      f.input :country, :as => :select, :collection => Country.all
      f.input :state, :as => :select, :collection => State.all
      f.input :lattitude
      f.input :longitude
      f.input :google_earth_file, :as => :file
    end
    f.actions
  end
end
