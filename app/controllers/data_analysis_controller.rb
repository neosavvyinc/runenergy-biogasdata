class DataAnalysisController < DataInterfaceController
  include AjaxHelp
  before_filter :authenticate_user!

  def index
    all_view_classes
  end

  def readings
    if not ajax_value_or_nil(params[:asset_id]).nil? or (not ajax_value_or_nil(params[:site_id]).nil? and not ajax_value_or_nil(params[:monitor_class_id]).nil?)
      unless ajax_value_or_nil(params[:asset_id]).nil?
        readings = Reading.where(:asset_id => params[:asset_id])
      else
        readings = Reading.where(:location_id => params[:site_id], :monitor_class_id => params[:monitor_class_id])
      end
      unless ajax_value_or_nil(params[:start_date_time]).nil?
        readings = readings.where('taken_at >= ?', DateTime.strptime(params[:start_date_time].to_s, '%s'))
      end
      unless ajax_value_or_nil(params[:end_date_time]).nil?
        readings = readings.where('taken_at <= ?', DateTime.strptime(params[:end_date_time].to_s, '%s'))
      end
      render json: {:readings => readings}
    else
      render json: {:error => 'You must pass valid parameter to retrieve readings for analysis'}, :status => 400
    end
  end

  def monitor_points
    unless ajax_value_or_nil(params[:asset_id]).nil?
      monitor_points = Asset.find(params[:asset_id].to_i).monitor_points
      render json: {monitor_points: monitor_points}
    else
      render json: {:error => 'You must pass valid parameter to retrieve monitor points for analysis'}, :status => 400
    end
  end


end