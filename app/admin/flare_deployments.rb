ActiveAdmin.register FlareDeployment, :as => "Deployment" do
  menu :parent => "Flares"

  index do
    column :client_flare_unique_identifier
    column :customer
    column :location
    column :first_reading
    column :last_reading
    default_actions
  end
end
