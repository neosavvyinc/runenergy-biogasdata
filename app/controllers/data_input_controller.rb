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
      @readings = Reading.process_csv(params[:files][:csv])
    end
    all_view_classes
  end

end