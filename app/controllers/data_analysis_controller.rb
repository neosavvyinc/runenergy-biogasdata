class DataAnalysisController < ApplicationController
  include AjaxHelp
  before_filter :authenticate_user!

  def index
    all_view_classes
  end

  def readings
    if not ajax_value_or_nil(params[:landfill_operator_id]).nil? and
        not ajax_value_or_nil(params[:site_id]).nil? and
        not ajax_value_or_nil(params[:section_id]).nil? and
        not ajax_value_or_nil(params[:monitor_class_id]).nil?
      readings = Reading.where(:monitor_class_id => params[:monitor_class_id].to_i)
      render json: {:readings => readings}
    else
      render json: {:error => 'You must pass valid parameter to retrieve readings for analysis'}, :status => 400
    end
  end

  protected
  def all_view_classes
    @landfill_operators = User.all
    @sites = Location.all
    @sections = Section.all
    @assets = Asset.all
    @monitor_classes = MonitorClass.all
    @filter_types = DataAnalysisFilter.all.map {
        |d| {:filter => d, :name => d.description}
    }
  end
end