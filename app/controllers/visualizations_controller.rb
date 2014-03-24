class VisualizationsController < DataInterfaceController
  include AjaxHelp
  before_filter :authenticate_user!

  def monitor_point_progress
    @monitor_point = MonitorPoint.find(params[:monitor_point_id])
    @readings = Reading.where(:location_id => params[:site], :monitor_class_id => params[:monitor_class]).map {
        |r| [(r.taken_at.try(:strftime, '%Y%m%d') || r.created_at.try(:strftime, '%Y%m%d')), JSON.parse(r.data)[@monitor_point.try(:name)]]
    }
  end

  def heat_map
    unless params[:site].nil? or params[:monitor_class].nil?
      location = Location.find(params[:site])
      monitor_class = MonitorClass.find(params[:monitor_class])
      @locations_monitor_class = LocationsMonitorClass.lazy_load(params[:site], params[:monitor_class])
      @asset_map = HeatMapDetail.asset_map(:location => location, :monitor_class => monitor_class)
      @reading_map = HeatMapDetail.reading_map(:location => location,
                                               :monitor_class => monitor_class,
                                               :monitor_point => MonitorPoint.find(params[:monitor_point_id]),
                                               :start_date => date_time_or_nil(params[:start_date]),
                                               :end_date => date_time_or_nil(params[:end_date])
      )
      puts 'Something'
    else
      render json: {:error => 'You must pass in a valid location and monitor class id.'}, :status => 400
    end
  end

end