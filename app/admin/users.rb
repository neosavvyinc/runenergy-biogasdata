ActiveAdmin.register User, :as => 'Customers/Viewers' do
  menu :parent => 'Users'

  show do
    panel 'Customer Details' do
      h4 customers_viewers.name
      h6 customers_viewers.email
    end
    panel 'Permssions' do
      h4 customers_viewers.try(:user_type).try(:name)
      h6 customers_viewers.edit_permission ? 'Has Edit Permission' : 'Does not have Edit Permission'
    end
    panel 'Assets' do
      assets = customers_viewers.all_locations.map {|l| l.assets}.flatten
      h3 "Total: #{assets.size}"
      customers_viewers.all_locations.each do |l|
        h4 "#{l.site_name}: #{l.assets.try(:size)}"
      end
      assets.each do |a|
        h6 "#{a.try(:location).try(:site_name)}, #{a.try(:monitor_class).try(:name)}: #{a.unique_identifier}"
      end
    end
  end

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
      f.input :edit_permission
      f.input :user_groups, :as => :select, :collection => UserGroup.all, :input_html => {:style => 'height: 300px; width: 300px;'}
    end
    f.actions
  end

  controller do

    def update
      if params[:customers_viewers][:password].blank?
        params[:customers_viewers].delete('password')
        params[:customers_viewers].delete('password_confirmation')
      end
      super
    end

  end
end
