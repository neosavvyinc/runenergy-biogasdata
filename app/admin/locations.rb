ActiveAdmin.register Location, :as => "Site" do
  menu :parent => "Locations"

  index do
    column :site_name
    column :address
    column :lattitude
    column :longitude
    default_actions
  end
end
