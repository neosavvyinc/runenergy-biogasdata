ActiveAdmin.register UserGroup do
  menu :parent => 'Users'

  form do |f|
    f.inputs 'User Group' do
      f.input :name
      f.input :edit_permission
      f.input :users, :as => :select, :collection => User.where(:user_type_id => [UserType.CUSTOMER.id, UserType.OVERSEER.id, UserType.WORKER.id]), :input_html => {:style => 'height: 300px; width: 300px;'}
      f.input :locations, :as => :select, :collection => Location.all, :input_html => {:style => 'height: 300px; width: 300px;'}
      f.input :device_profiles, :as => :select, :collection => DeviceProfile.all, :input_html => {:style => 'height: 300px; width: 300px;'}
    end
    f.actions
  end

end
