class DataInputController < ApplicationController
  include AjaxHelp

  before_filter :authenticate_user!

  def create
    all_monitor_classes
  end

  def import
    all_monitor_classes
  end

  protected
  def all_monitor_classes
    @monitor_classes = MonitorClass.all
  end
end