ActiveAdmin.register FlareSpecification do
  menu :parent => "Flares"

  index do
    column :flare_unique_identifier
    column :owner
    column :pause
    default_actions
  end

  form do |f|
    f.inputs "Flare Specification" do
      f.input :owner,  :as => :select, :collection => Company.all
      f.input :manufacturer, :as => :select, :collection => Company.all
      f.date_select :purchase_date
      f.input :flare_unique_identifier
      f.input :capacity_scmh
      f.input :web_address
      f.input :ftp_address
      f.input :data_location
      f.input :flare_data_mapping, :as => :select, :collection => FlareDataMapping.all
      f.input :username
      f.input :password
      f.input :pause, :as => :boolean
    end
    f.actions
  end
end
