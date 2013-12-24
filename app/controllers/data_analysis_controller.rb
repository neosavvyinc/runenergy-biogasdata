class DataAnalysisController < DataInterfaceController
  include AjaxHelp
  before_filter :authenticate_user!

  def index
    all_view_classes
  end

  def readings
    unless ajax_value_or_nil(params[:site_id]).nil?
      readings = Location.find(params[:site_id].to_i).readings
      render json: {:readings => readings}
    else
      render json: {:error => 'You must pass valid parameter to retrieve readings for analysis'}, :status => 400
    end
  end


end