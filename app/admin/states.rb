ActiveAdmin.register State do
  menu :parent => "Locations"

  index do
    column :name
    default_actions
  end
end
