class DataInterfaceController < ApplicationController

  protected
  def all_view_classes(sections=true, assets=true, monitor_points=true)
    @landfill_operators = current_user.all_operators
    @sites = current_user.all_locations
    if sections
      @sections = Section.all
    end
    if assets
      @assets = Asset.all
    end
    @monitor_classes = MonitorClass.all
    @filter_types = DataAnalysisFilter.all.map {
        |d| {:filter => d, :name => d.description}
    }
    if monitor_points
      @monitor_points = MonitorPoint.map_with_key(MonitorPoint.all, :name)
    end
  end

  def all_dashboard_action_selections
    @operator = User.where(:id => params[:operator]).first
    @site = Location.where(:id => params[:site]).first
    @monitor_class = MonitorClass.where(:id => params[:monitor_class]).first
    @section = Section.where(:id => params[:section]).first
    @asset = Asset.where(:id => params[:asset]).first

    @locations_monitor_class = LocationsMonitorClass.where(:location_id => params[:site], :monitor_class_id => params[:monitor_class]).first
  end

end