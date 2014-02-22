class VisualizationsController < DataInterfaceController
  include AjaxHelp
  before_filter :authenticate_user!

  def monitor_point_progress

  end

end