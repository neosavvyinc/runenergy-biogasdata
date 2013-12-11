class DataInputController < ApplicationController
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
          not ajax_value_or_nil(params[:reading]).nil?
        field_log = FieldLog.find_or_create_by_data(params[:field_log])
        reading = Reading.create({:data => params[:reading],
                                  :asset_id => params[:asset_id].to_i,
                                  :monitor_class_id => params[:monitor_class_id].to_i,
                                  :field_log_id => field_log.id})
        render json: {:field_log => field_log, :reading => reading}
      else
        render json: {:error => 'Invalid param for reading create request.'}, :status => 400
      end
    else
      all_view_classes
    end
  end

  def import
    all_view_classes
  end

  protected
  def all_view_classes
    @landfill_operators = User.all
    @sites = Location.all
    @sections = Section.all
    @assets = Asset.all
    @monitor_classes = MonitorClass.all
  end

end