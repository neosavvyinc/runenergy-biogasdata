class VisualizationsController < DataInterfaceController
  include AjaxHelp
  before_filter :authenticate_user!

  def monitor_point_progress
    @monitor_point = MonitorPoint.find(params[:monitor_point_id])
    @readings = Reading.where(:location_id => params[:site], :monitor_class_id => params[:monitor_class]).map {
      |r| [(r.taken_at.try(:strftime, '%Y%m%d') || r.created_at.try(:strftime, '%Y%m%d')), JSON.parse(r.data)[@monitor_point.try(:name)]]
    }
  end

end