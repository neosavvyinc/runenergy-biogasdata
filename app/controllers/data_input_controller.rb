class DataInputController < DataInterfaceController
  include AjaxHelp

  before_filter :authenticate_user!

  def readings
    if not ajax_value_or_nil(params[:site_id]).nil? and
        not ajax_value_or_nil(params[:monitor_class_id]).nil?
      readings = Reading.where(:location_id => params[:site_id]).where(:monitor_class_id => params[:monitor_class_id]).order('created_at DESC').limit(15)
      render json: readings
    else
      render json: {:error => 'Invalid asset_id or monitor_class_id param!'}, :status => 400
    end
  end

  def assets
    unless ajax_value_or_nil(params[:site_id]).nil? or
        ajax_value_or_nil(params[:monitor_class_id]).nil? or
        ajax_value_or_nil(params[:asset_unique_identifier]).nil?
      render json: {:data => Asset.where(:location_id => params[:site_id], :monitor_class_id => params[:monitor_class_id]).
          where(["unique_identifier LIKE :uid", {:uid => "#{params[:asset_unique_identifier]}%"}]).
          collect { |a| {:uid => a.unique_identifier} }
      }
    else
      render json: []
    end
  end

  def create
    if request.method == 'POST'
      if not ajax_value_or_nil(params[:site_id]).nil? and
          not ajax_value_or_nil(params[:asset_unique_identifier]).nil? and
          not ajax_value_or_nil(params[:monitor_class_id]).nil? and
          not ajax_value_or_nil(params[:field_log]).nil? and
          not ajax_value_or_nil(params[:reading]).nil? and
          not ajax_value_or_nil(params[:date_time]).nil?
        field_log = FieldLog.find_or_create_by_data(params[:field_log])
        asset = Asset.lazy_load(params[:site_id], params[:monitor_class_id], params[:asset_unique_identifier])
        reading = Reading.create({:data => params[:reading],
                                  :location_id => params[:site_id],
                                  :asset_id => asset.id,
                                  :monitor_class_id => params[:monitor_class_id],
                                  :field_log_id => field_log.id,
                                  :taken_at => DateTime.strptime(params[:date_time].to_s, '%s')})
        render json: {:field_log => field_log, :reading => reading}
      else
        render json: {:error => 'Invalid param for reading create request.'}, :status => 400
      end
    else
      all_view_classes(false, false, false)
    end
  end

  def create_monitor_point
    unless ajax_value_or_nil(params[:site_id]).nil? or
        ajax_value_or_nil(params[:monitor_class_id]).nil? or
        ajax_value_or_nil(params[:name]).nil? or
        ajax_value_or_nil(params[:unit]).nil?
      monitor_point = MonitorPoint.create(:name => params[:name], :unit => params[:unit])

      #Add MonitorPoint to the LocationsMonitorClass for the location and monitor class
      LocationsMonitorClass.
          lazy_load(params[:site_id], params[:monitor_class_id]).
          monitor_points << monitor_point

      render json: monitor_point
    else
      render json: {:error => 'Invalid params for creating a monitor point.'}, :status => 400
    end
  end

  def import
    @readings = nil
    if request.method === 'POST'
      unless params[:column_definition_row].blank? or params[:first_data_row].blank?
        #Return readings for editing
        @readings = Reading.process_csv(
            params[:files][:csv],
            params[:column_definition_row].to_i,
            params[:first_data_row].to_i,
            params[:last_data_row].try(:to_i)
        )
        all_dashboard_action_selections
      else
        @error = 'Column Name Row and First Data Row are required for import.'
      end
    end
    all_view_classes(false, false, false)
  end

  def complete_import
    unless params[:readings].nil? or params[:readings].empty? or params[:reading_mods].nil? or params[:site_id].blank? or params[:monitor_class_id].blank? or params[:asset_column_name].blank?
      LocationsMonitorClass.create_caches(params[:site_id].to_i, params[:monitor_class_id].to_i, params[:reading_mods][:column_to_monitor_point_mappings], params[:reading_mods][:deleted_columns], params[:asset_column_name])
      readings = Reading.process_edited_collection(params[:readings],
                                                   params[:reading_mods][:column_to_monitor_point_mappings],
                                                   params[:reading_mods][:deleted_columns],
                                                   params[:reading_mods][:deleted_row_indices],
                                                   params[:site_id].to_i,
                                                   params[:monitor_class_id].to_i,
                                                   params[:asset_column_name]
      )
      render json: {readings: readings}
    else
      render json: {:error => 'The reading params were not set in the session, do not make this request until you have first called the import method.'}, :status => 400
    end
  end

end