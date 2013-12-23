ActiveAdmin.register User, :as => 'Customers/Viewers' do
  menu :parent => 'Users'

  index do
    column :name
    column :email
    column :user_type
    column :current_sign_in_at
    column :last_sign_in_at
    column :sign_in_count
    default_actions
  end

  filter :name
  filter :email

  form do |f|
    f.inputs 'User Details' do
      f.input :user_type,  :as => :select, :collection => UserType.all
      f.input :name
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :locations, :as => :select, :collection => Location.all, :input_html => {:style => 'height: 300px; width: 300px;'}
    end
    f.actions
  end
end
