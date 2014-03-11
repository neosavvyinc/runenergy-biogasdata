ActiveAdmin.register Asset do
  menu :parent => 'Site Management'

  index do
    column :unique_identifier
    column :location
    column :section
    column :monitor_class
    default_actions
  end

  show do
    panel 'Details' do
      h4 "ID: #{asset.unique_identifier}"
      h6 asset.name
      h6 asset.location.site_name
      h6 asset.monitor_class.name
      h6 asset.section.try(:display_name)
    end
    panel 'Properties' do
      asset.asset_property_values.each do |apv|
        h6 "#{apv.name} #{apv.value}"
      end
    end
  end

  form do |f|
    f.inputs 'Asset' do
      f.input :unique_identifier
      f.input :name
      f.input :location, :as => :select, :collection => Location.all
      f.input :section, :as => :select, :collection => asset.available_sections
      f.input :monitor_class, :as => :select, :collection => MonitorClass.all
      f.has_many :asset_property_values, :allow_destroy => true do |apv|
        apv.input :asset_property, :as => :select, :collection => AssetProperty.all
        apv.input :value
        apv.input :_destroy, :as => :boolean, :label => 'Remove From Asset'
      end
    end
    f.actions
  end

  action_item :only => :show do
    link_to('Duplicate', clone_admin_asset_path(asset))
  end

  member_action :clone, method: :get do
    @asset = Asset.find(params[:id]).try(:dup)
    render :new, layout: false
  end
end
