ActiveAdmin.register FlareSpecification do
  menu :parent => "Flares"

  index do
    column :flare_unique_identifier
    column :owner
    column :pause
    default_actions
  end
end
