ActiveAdmin.register Location, :as => "Site" do
  menu :parent => "Locations"

  index do
    column :site_name
    column :address
    column :lattitude
    column :longitude
    default_actions
  end

  show do
    panel "User Groups" do
      table_for site.user_groups do
        column :name
      end
    end
    panel "Users" do
      table_for site.users do
        column :name
        column :email
      end
    end
    panel "Monitor Classes" do
      table_for site.monitor_classes do
        column :name
      end
    end
    panel "Details" do
      h6 "Created At: #{site.created_at}"
      h6 "Updated At: #{site.updated_at}"
    end
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
      f.input :monitor_classes, :as => :select, :collection => MonitorClass.all
    end
    f.actions
  end
end
