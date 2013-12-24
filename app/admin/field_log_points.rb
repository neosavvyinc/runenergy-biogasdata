ActiveAdmin.register FieldLogPoint do

  menu :parent => 'Site Management'

  index do
    column :name
    default_actions
  end

end
