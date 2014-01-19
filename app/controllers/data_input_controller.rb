class DataInputController < DataInterfaceController
  include AjaxHelp

  before_filter :authenticate_user!

  def readings
    if not ajax_value_or_nil(params[:asset_id]).nil? and not ajax_value_or_nil(params[:monitor_class_id]).nil?
      readings = Reading.where(:asset_id => params[:asset_id].to_i).where(:monitor_class_id => params[:monitor_class_id].to_i).limit(15)
      render json: readings
    else
      render json: {:error => 'Invalid asset_id or monitor_class_id param!'}, :status => 400
    end
  end

  def create
    if request.method == 'POST'
      if not ajax_value_or_nil(params[:asset_id]).nil? and
          not ajax_value_or_nil(params[:monitor_class_id]).nil? and
          not ajax_value_or_nil(params[:field_log]).nil? and
          not ajax_value_or_nil(params[:reading]).nil? and
          not ajax_value_or_nil(params[:date]).nil?
        field_log = FieldLog.find_or_create_by_data(params[:field_log])
        reading = Reading.create({:data => params[:reading],
                                  :asset_id => params[:asset_id].to_i,
                                  :monitor_class_id => params[:monitor_class_id].to_i,
                                  :field_log_id => field_log.id,
                                  :taken_at => date_time_from_js(params[:date],
                                                                 ajax_value_or_nil(params[:time]))})
        render json: {:field_log => field_log, :reading => reading}
      else
        render json: {:error => 'Invalid param for reading create request.'}, :status => 400
      end
    else
      all_view_classes
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
    all_view_classes(false, false)
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