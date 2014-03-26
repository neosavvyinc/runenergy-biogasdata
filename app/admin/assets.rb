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
    panel 'Heat Map Detail' do
      h6 "X: #{asset.try(:heat_map_detail).try(:x)}"
      h6 "Y: #{asset.try(:heat_map_detail).try(:y)}"
    end
    panel 'Ftp Detail' do
      h6 asset.try(:ftp_detail).try(:url)
      h6 asset.try(:ftp_detail).try(:folder_path)
      h6 asset.try(:ftp_detail).try(:username)
      h6 asset.try(:ftp_detail).try(:password)
      h6 "Minimum Date: #{asset.try(:ftp_detail).try(:minimum_date)}"
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
      f.inputs 'Heat Map Detail', :for => [:heat_map_detail, asset.heat_map_detail || HeatMapDetail.new] do |hmd|
        hmd.input :x
        hmd.input :y
        hmd.input :symbol_id
      end
      f.inputs 'FTP Detail', :for => [:ftp_detail, asset.ftp_detail || FtpDetail.new] do |fd|
        fd.input :url, :input_html => {:style => 'height: 40px;'}
        fd.input :folder_path
        fd.input :username
        fd.input :password
        fd.input :date_column_name
        fd.input :time_column_name
        fd.input :minimum_date
        fd.has_many :ftp_column_monitor_points, :allow_destroy => true do |fcmp|
          fcmp.input :column_name
          fcmp.input :monitor_point, :as => :select, :collection => MonitorPoint.all
          fcmp.input :_destroy, :as => :boolean, :label => 'Remove From FTP Detail'
        end
      end
      f.has_many :asset_property_values, :allow_destroy => true do |apv|
        apv.input :asset_property, :as => :select, :collection => AssetProperty.all
        apv.input :value
        apv.input :_destroy, :as => :boolean, :label => 'Remove From Asset'
      end
    end
    f.actions
  end

  action_item :only => [:show, :edit] do
    link_to('Duplicate', clone_admin_asset_path(asset))
  end

  member_action :clone, method: :get do
    @asset = Asset.find(params[:id]).try(:dup)
    render :new, layout: false
  end
end
