ActiveAdmin.register Location, :as => "Site" do
  menu :parent => "Locations"

  index do
    column :site_name
    column :address
    column :lattitude
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
      f.input :user_groups, :as => :select, :collection => UserGroup.all
      f.input :users, :as => :select, :collection => User.all
    end
    f.actions
  end
end
