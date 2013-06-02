ActiveAdmin.register AttributeNameMapping, :as => "Columns" do
  menu :parent => "Flares"

  index do
    column :attribute_name
    column :display_name
    column :units
    column :significant_digits
    default_actions
  end
end
