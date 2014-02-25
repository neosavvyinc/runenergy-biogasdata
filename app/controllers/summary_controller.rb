class SummaryController < DataInterfaceController
  include AjaxHelp
  before_filter :authenticate_user!

  def locations
    all_view_classes
  end

end