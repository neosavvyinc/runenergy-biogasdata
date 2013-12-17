class DataAnalysisController < ApplicationController
  include AjaxHelp
  before_filter :authenticate_user!

  def index
    all_view_classes
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