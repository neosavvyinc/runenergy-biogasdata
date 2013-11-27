class MobileRigController < ApplicationController
  include AjaxHelp

  def index
    @locations = Location.all
    @monitor_classes = MonitorClass.all
  end
end