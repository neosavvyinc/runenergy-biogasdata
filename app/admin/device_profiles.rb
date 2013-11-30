ActiveAdmin.register DeviceProfile do
  menu :parent => "Users"

  show do
    panel "User Groups" do
      table_for device_profile.user_groups do
        column :name
      end
    end
    panel "Users" do
      table_for device_profile.users do
        column :name
        column :email
      end
    end
    panel "Details" do
      h6 "Created At: #{device_profile.created_at}"
      h6 "Updated At: #{device_profile.updated_at}"
    end
  end

  form do |f|
    f.inputs 'Monitor Class' do
      f.input :name
      f.input :user_groups, :as => :select, :collection => UserGroup.all
      f.input :users, :as => :select, :collection => User.all
    end
    f.actions
  end

end
