class DataAnalysisController < DataInterfaceController
  include AjaxHelp
  before_filter :authenticate_user!

  def index
    all_view_classes
  end

  def readings
    if not ajax_value_or_nil(params[:asset_id]).nil? or not ajax_value_or_nil(params[:section_id]).nil? or
        (not ajax_value_or_nil(params[:site_id]).nil? and not ajax_value_or_nil(params[:monitor_class_id]).nil?)
      if not ajax_value_or_nil(params[:asset_id]).nil?
        readings = Reading.where(:asset_id => params[:asset_id])
      elsif not ajax_value_or_nil(params[:section_id]).nil?
        readings = Reading.joins(:asset).where(:assets => {:section_id => params[:section_id]})
      else
        readings = Reading.where(:location_id => params[:site_id], :monitor_class_id => params[:monitor_class_id])
      end
      unless ajax_value_or_nil(params[:start_date_time]).nil?
        readings = readings.where('taken_at >= ?', DateTime.strptime(params[:start_date_time].to_s, '%s'))
      end
      unless ajax_value_or_nil(params[:end_date_time]).nil?
        readings = readings.where('taken_at <= ?', DateTime.strptime(params[:end_date_time].to_s, '%s'))
      end
      lmc = LocationsMonitorClass.where(:location_id => params[:site_id], :monitor_class_id => params[:monitor_class_id]).first
      render json: {
          :readings => readings
          .page(params[:offset].try(:to_i) || 0)
          .per(params[:count].try(:to_i) || 500)
          .order('taken_at DESC').map { |r| r.add_calculations_as_json(lmc) }
      }
    else
      render json: {:error => 'You must pass valid parameter to retrieve readings for analysis'}, :status => 400
    end
  end


  def update
    unless ajax_value_or_nil(params[:id]).nil?
      r = Reading.find(params[:id])
      lmc = LocationsMonitorClass.lazy_load(r.location_id, r.monitor_class_id)
      r.update_attribute(:data, params.except('id', 'Date Time', 'controller', 'action', 'data_analysi', 'Asset', *lmc.calculation_names))
      unless params['Asset'].nil? or params['Asset'].blank?
        r.update_attribute(:asset_id, Asset.lazy_load(r.location_id, r.monitor_class_id, params['Asset']).id)
      end
      unless params['Date Time'].nil? or params['Date Time'].blank?
        r.update_attribute(:taken_at, DateTime.strptime(params['Date Time'], '%d/%m/%y, %H:%M:%S'))
      end
      render json: r
    else
      render json: {:error => 'You must pass a reading ID and data to update a reading'}, :status => 400
    end
  end

end