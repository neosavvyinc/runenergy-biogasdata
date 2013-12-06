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
    @sections = Section.all
    @assets = Asset.all
    @monitor_classes = MonitorClass.all
  end
end