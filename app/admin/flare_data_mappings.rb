ActiveAdmin.register FlareDataMapping, :as => "Data Mapping" do
  menu :parent => "Flares"

  index do
    column :name
    default_actions
  end
end
