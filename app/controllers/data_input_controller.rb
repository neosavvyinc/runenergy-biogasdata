class DataInputController < ApplicationController
  include AjaxHelp

  before_filter :authenticate_user!

  def create
    all_view_classes
  end

  def import
    all_view_classes
  end

  protected
  def all_view_classes
    @landfill_operators = User.all
    @sites = Location.all
    @monitor_classes = MonitorClass.all
    @sections = Section.all
  end
end